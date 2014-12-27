module DatabaseSystemHelper
  def db(name)
    yield if name.to_s == SexyScopesSpec.database_system
  end

  def except_db(name)
    yield if name.to_s != SexyScopesSpec.database_system
  end
end
