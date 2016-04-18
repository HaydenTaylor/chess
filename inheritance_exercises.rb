class Employee
  def initialize(name, title, salary, boss)
    @name = name
    @title = title
    @salary = salary
    @boss = boss

    work_under_manager unless boss.nil?
  end

  def bonus(multiplier)
    @salary * multiplier
  end

  protected
  def report_salary
    @salary
  end

  private
  def work_under_manager
    @boss.add_employee(self)
  end
end

class Manager < Employee
  def initialize(name, title, salary, boss, employees = [])
    super(name, title, salary, boss)
    @employees = employees
  end

  def bonus(multiplier)
    salary_of_each_employee * multiplier
  end

  def add_employee(employee)
    @employees << employee
  end

  protected
  def salary_of_each_employee
    combined_salary = 0

    @employees.each do |underling|
      if underling.is_a?(Manager)
        combined_salary += underling.salary_of_each_employee + underling.report_salary
      else
        combined_salary += underling.report_salary
      end
    end

    combined_salary
  end
end
