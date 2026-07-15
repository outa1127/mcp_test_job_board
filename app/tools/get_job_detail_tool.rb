# app/tools/get_job_detail_tool.rb
class GetJobDetailTool < MCP::Tool
  tool_name "get_job_detail"
  description "求人IDを指定して、求人の詳細情報(説明文・企業情報含む)を取得します。"

  input_schema(
    properties: {
      id: { type: "integer", description: "求人ID(search_jobsの結果に含まれるid)" }
    },
    required: [ "id" ]
  )

  class << self
    def call(id:, server_context: nil)
      job = JobPosting.includes(:company).find_by(id: id)

      unless job
        return MCP::Tool::Response.new([
          { type: "text", text: "ID=#{id} の求人は見つかりませんでした。" }
        ])
      end

      detail = {
        id: job.id,
        title: job.title,
        description: job.description,
        salary_min: job.salary_min,
        salary_max: job.salary_max,
        tech_stack: job.tech_stack,
        remote_ok: job.remote_ok,
        company: {
          name: job.company.name,
          industry: job.company.industry,
          employee_count: job.company.employee_count
        }
      }

      MCP::Tool::Response.new([
        { type: "text", text: JSON.pretty_generate(detail) }
      ])
    end
  end
end
