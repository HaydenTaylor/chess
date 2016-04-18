class Employee
  def initialize(name, title, salary, boss)
    @name = name
    @title = title
    @salary = salary
    @boss = boss
  end

  def bonus(multiplier)
  end
end

class Manager < Employee
  def initialize
    # override
  end

  def bonus(multiplier)
    # override
  end
end
