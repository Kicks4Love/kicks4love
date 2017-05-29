# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )

Rails.application.config.assets.precompile += %w( bootstrap.min.css bootstrap.min.js )
Rails.application.config.assets.precompile += %w( index.css feature.css calendar.css trend.css oncourt.css rumors.css contact.css show.css)
Rails.application.config.assets.precompile += %w( index.js feature.js calendar.js trend.js oncourt.js rumors.js contact.js show.js)
Rails.application.config.assets.precompile += %w( admin/admin.css )
Rails.application.config.assets.precompile += %w( admin/posts.js admin/calendar.js admin/features.js admin/oncourt.js admin/trend.js admin/rumors.js admin/streetsnap.js)
