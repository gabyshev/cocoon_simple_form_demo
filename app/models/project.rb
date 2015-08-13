class Project < ActiveRecord::Base
  TASKS_COUNT = 4

  has_many :tasks
  has_many :people
  belongs_to :owner, :class_name => 'Person'

  has_many :project_tags
  has_many :tags, :through => :project_tags, :class_name => 'Tag'

  accepts_nested_attributes_for :tasks, :reject_if => :all_blank, :allow_destroy => true
  accepts_nested_attributes_for :people, :reject_if => :all_blank, :allow_destroy => true
  accepts_nested_attributes_for :owner, :reject_if => :all_blank
  accepts_nested_attributes_for :tags
  accepts_nested_attributes_for :project_tags, :allow_destroy => true

  validate :tasks_count

  private

  def tasks_count
    if existing_tasks.size != TASKS_COUNT
      errors.add :base, message: :should_have_4_tasks
    end
  end

  def existing_tasks
    tasks.reject(&:marked_for_destruction?)
  end
end
