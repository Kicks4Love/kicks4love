FactoryBot.define do
    factory :admin_user do
      email "user@kicks4love.com"
      username "Robin Lou"
      password "grandcherokee"

      factory :root_admin_user do
        email "root@kicks4love.com"
      end
    end
end
