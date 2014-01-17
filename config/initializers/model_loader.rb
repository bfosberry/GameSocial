if Rails.env == "development"
  Dir.foreach("#{Rails.root}/app/models") do |model_name|
    require_dependency model_name if model_name =~ /\w*\.rb$/
  end 
end
