#Sass::Engine::DEFAULT_OPTIONS[:load_paths].tap do |load_paths|
#  load_paths << "#{Rails.root}/app/assets/stylesheets"
#  load_paths << "#{Gem.loaded_specs['compass'].full_gem_path}/frameworks/compass/stylesheets"
#  load_paths << "#{Gem.loaded_specs['compass'].full_gem_path}/frameworks/blueprint/stylesheets"  
#end
Rails.configuration.sass.tap do |config|
  config.load_paths << "#{Rails.root}/app/assets/stylesheets"
  config.load_paths << "#{Gem.loaded_specs['compass'].full_gem_path}/frameworks/compass/stylesheets"
  config.load_paths << "#{Gem.loaded_specs['compass'].full_gem_path}/frameworks/blueprint/stylesheets"
end
