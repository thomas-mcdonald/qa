class ChangeSubjectTypeToString < ActiveRecord::Migration
  def change
    remove_column :badges, :subject_type
    add_column :badges, :subject_type, :string
  end
end
