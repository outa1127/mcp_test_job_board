class SearchJobsTool < MCP::Tool
  tool_name "search_jobs"
  description <<~DESC
    求人を検索します。技術キーワード・最低年収・リモート可否で絞り込めます。
    条件を指定しない場合は全件(最大20件)を返します。
  DESC

  input_schema(
    properties: {
      tech: {
        type: "string",
        description: "技術スタックのキーワード(例: Ruby, React, Kubernetes)"
      },
      salary_min: {
        type: "integer",
        description: "最低年収(円)。この金額以上の求人を返す"
      },
      remote_only: {
        type: "boolean",
        description: "trueの場合、リモート可の求人のみ返す"
      }
    },
    required: []
  )

  class << self
    def call(tech: nil, salary_min: nil, remote_only: false)
      jobs = JobPosting.includes(:company).limit(20)
      jobs = jobs.tech(tech) if tech.present?
      jobs = jobs.salary_gte(salary_min) if salary_min.present?
      jobs = jobs.remote if remote_only

      results = jobs.map do |job|
        {
          id: job.id,
          title: job.title,
          company: job.company.name,
          salary_range: "#{job.salary_min} - #{job.salary_max}",
          tech_stack: job.tech_stack,
          remote_ok: job.remote_ok
        }
      end

      MCP::Tool::Response.new([
        { type: "text", text: JSON.pretty_generate(results) }
      ])
    end
  end
end
