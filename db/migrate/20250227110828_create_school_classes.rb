class CreateSchoolClasses < ActiveRecord::Migration[8.0]
  def change
    create_table :school_classes do |t|
      t.integer :number
      t.string :letter
      t.integer :students_count
      t.integer :school_id

      t.timestamps
    end
  end
end
