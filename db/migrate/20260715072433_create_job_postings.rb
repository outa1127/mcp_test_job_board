class CreateJobPostings < ActiveRecord::Migration[8.1]
  def change
    create_table :job_postings do |t|
      t.references :company, null: false, foreign_key: true
      t.string :title
      t.text :description
      t.integer :salary_min
      t.integer :salary_max
      t.string :tech_stack
      t.boolean :remote_ok

      t.timestamps
    end
  end
end
