require 'helper'

class ModestPresenterSpec < MiniTest::Spec
  include ModestPresenters

  class Person < Struct.new(:first_name, :last_name)
  end

  class Student < Person
    attr_accessor :enrolled_courses
  end

  class Teacher < Person
    attr_accessor :department, :professorship, :teaching_courses
  end

  class PersonPresenter < ModestPresenter
    def full_name
      "#{first_name} #{last_name}"
    end
  end

  class StudentPresenter < PersonPresenter
  end

  class TeacherPresenter < PersonPresenter
  end

  it "expects a model and a context" do
    student = Student.new("Ed", "Kim")
    StudentPresenter.new(student, Object.new)
  end

  it "accepts a Hash as a third argument" do
    student = Student.new("Ed", "Kim")
    StudentPresenter.new(student, Object.new, :is_learning_ruby => true)
  end

  describe "A modest presenter" do
    before do
      @student = Student.new("Ed", "Kim")
      @context = Struct.new(:render).new("you called render")
      @presenter = StudentPresenter.new(@student, @context)
    end

    it "first delegates calls to its model" do
      @student.first_name.must_equal @presenter.first_name
    end

    it "delegates messages unsupported by its model to its context" do
      @context.render.must_equal @presenter.render
    end

    describe "when presenting" do
      it "evaluates a provided block in the context of the presenter" do
        @presenter.present do
          self.must_be_instance_of StudentPresenter
          @model = "Ohai the block was called"
        end
        @presenter.model.must_equal "Ohai the block was called"
      end
    end
  end
end
