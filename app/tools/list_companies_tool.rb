# app/tools/list_companies_tool.rb
class ListCompaniesTool < MCP::Tool
  tool_name "list_companies"
  description "登録されている企業の一覧を、各社の求人数とあわせて返します。"

  input_schema(properties: {}, required: [])

  class << self
    def call(server_context: nil)
      companies = Company.left_joins(:job_postings)
                         .group(:id)
                         .select("companies.*, COUNT(job_postings.id) AS jobs_count")
                         .map do |c|
        {
          name: c.name,
          industry: c.industry,
          employee_count: c.employee_count,
          open_positions: c.jobs_count
        }
      end

      MCP::Tool::Response.new([
        { type: "text", text: JSON.pretty_generate(companies) }
      ])
    end
  end
end
