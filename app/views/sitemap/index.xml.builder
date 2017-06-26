xml.instruct! :xml, :version=>'1.0'

xml.tag! 'urlset', "xmlns" => "http://www.sitemaps.org/schemas/sitemap/0.9" do

  xml.url do
    xml.loc "#{root_url}features"
    xml.lastmod Date.today
    xml.changefreq "monthly"
    xml.priority 0.8
  end

  xml.url do
    xml.loc "#{root_url}calendar"
    xml.lastmod Date.today
    xml.changefreq "monthly"
    xml.priority 0.8
  end

  xml.url do
    xml.loc "#{root_url}oncourt"
    xml.lastmod Date.today
    xml.changefreq "monthly"
    xml.priority 0.7
  end

  xml.url do
    xml.loc "#{root_url}trend"
    xml.lastmod Date.today
    xml.changefreq "monthly"
    xml.priority 0.7
  end

  xml.url do
    xml.loc "#{root_url}streetsnap"
    xml.lastmod Date.today
    xml.changefreq "monthly"
    xml.priority 0.6
  end

  xml.url do
    xml.loc "#{root_url}rumors"
    xml.lastmod Date.today
    xml.changefreq "monthly"
    xml.priority 0.6
  end

  unless @all_posts[:feature_posts].blank?
    @all_posts[:feature_posts].each do |feature_post|
      xml.url do
        xml.loc "#{features_url}/#{feature_post.id}"
        xml.lastmod feature_post.updated_at.to_date
        xml.changefreq "daily"
      end
    end
  end

  unless @all_posts[:oncourt_posts].blank?
    @all_posts[:oncourt_posts].each do |oncourt_post|
      xml.url do
        xml.loc "#{oncourt_url}/#{oncourt_post.id}"
        xml.lastmod oncourt_post.updated_at.to_date
        xml.changefreq "daily"
      end
    end
  end

  unless @all_posts[:streetsnap_posts].blank?
    @all_posts[:streetsnap_posts].each do |streetsnap_post|
      xml.url do
        xml.loc "#{streetsnap_url}/#{streetsnap_post.id}"
        xml.lastmod streetsnap_post.updated_at.to_date
        xml.changefreq "daily"
      end
    end
  end

  unless @all_posts[:rumor_posts].blank?
    @all_posts[:rumor_posts].each do |rumor_post|
      xml.url do
        xml.loc "#{rumors_url}/#{rumor_post.id}"
        xml.lastmod rumor_post.updated_at.to_date
        xml.changefreq "daily"
      end
    end
  end

  unless @all_posts[:trend_posts].blank?
    @all_posts[:trend_posts].each do |trend_post|
      xml.url do
        xml.loc "#{trend_url}/#{trend_post.id}"
        xml.lastmod trend_post.updated_at.to_date
        xml.changefreq "daily"
      end
    end
  end

  xml.url do
    xml.loc "#{root_url}contact_us"
    xml.changefreq "yearly"
  end

  xml.url do
    xml.loc "#{root_url}privacy"
    xml.changefreq "yearly"
  end

end