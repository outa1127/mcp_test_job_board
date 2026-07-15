# db/seeds.rb
companies = [
  { name: "テックフォワード株式会社", industry: "SaaS", employee_count: 120 },
  { name: "株式会社データブリッジ", industry: "データ分析", employee_count: 45 },
  { name: "クラウドネスト株式会社", industry: "インフラ", employee_count: 300 }
].map { |attrs| Company.create!(attrs) }

JobPosting.create!([
  {
    company: companies[0],
    title: "バックエンドエンジニア(Rails)",
    description: "自社SaaSのバックエンド開発。Rails 8 + PostgreSQL。",
    salary_min: 7_000_000, salary_max: 10_000_000,
    tech_stack: "Ruby, Rails, PostgreSQL, AWS", remote_ok: true
  },
  {
    company: companies[0],
    title: "フロントエンドエンジニア",
    description: "React + TypeScript でのダッシュボード開発。",
    salary_min: 6_000_000, salary_max: 9_000_000,
    tech_stack: "React, TypeScript, Next.js", remote_ok: true
  },
  {
    company: companies[1],
    title: "データエンジニア",
    description: "データパイプラインの設計・構築。",
    salary_min: 8_000_000, salary_max: 12_000_000,
    tech_stack: "Python, BigQuery, Airflow", remote_ok: false
  },
  {
    company: companies[2],
    title: "SRE",
    description: "Kubernetes 基盤の運用と信頼性向上。",
    salary_min: 7_500_000, salary_max: 11_000_000,
    tech_stack: "Kubernetes, Terraform, Go, AWS", remote_ok: true
  },
  {
    company: companies[2],
    title: "Rails エンジニア(リードクラス)",
    description: "社内向け管理システムのテックリード。",
    salary_min: 9_000_000, salary_max: 13_000_000,
    tech_stack: "Ruby, Rails, MySQL", remote_ok: false
  }
])

puts "Seeded: #{Company.count} companies, #{JobPosting.count} job postings"
