FactoryBot.define do
    factory :calendar_post do
      release_date 1.day.ago
    end

    factory :feature_post do
      created_at 1.day.ago
    end

    factory :on_court_post do
      association :author, factory: :admin_user
      created_at 1.day.ago

      factory :on_court_post_with_link do
        content_en ["example"]
        content_cn ["例子"]
        main_images { ["example.jpg"] }
      end
    end

    factory :rumor_post do
      created_at 1.day.ago
    end

    factory :street_snap_post do
      created_at 1.day.ago
    end

    factory :trend_post do
      created_at 1.day.ago
    end
end