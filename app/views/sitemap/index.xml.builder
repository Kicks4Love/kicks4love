base_url = "http://#{request.host_with_port}"
xml.instruct! :xml, :version=>'1.0'

xml.tag! 'urlset', "xmlns" => "http://www.sitemaps.org/schemas/sitemap/0.9" do

  xml.url do
    xml.loc "#{features_url}/#{@feature_post.id}"
    xml.lastmod @feature_post.updated_at.to_date
    xml.changefreq "always"
    xml.priority 1.0
  end

  xml.url do
    xml.loc "#{base_url}/features"
    xml.lastmod Time.now.to_date
    xml.changefreq "monthly"
    xml.priority 0.8
  end

  xml.url do
    xml.loc "#{base_url}/oncourt"
    xml.lastmod Time.now.to_date
    xml.changefreq "monthly"
    xml.priority 0.7
  end

  xml.url do
    xml.loc "#{base_url}/calendar"
    xml.lastmod Time.now.to_date
    xml.changefreq "monthly"
    xml.priority 0.5
  end

end
