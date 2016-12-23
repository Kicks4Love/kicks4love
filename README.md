# kicks4love

## Setup instructions

1. **Ruby & Rails**
  - Make sure you have installed Ruby and Rails
  - Otherwise it will not work properly

2. **MySql**
  - We are using MySql
  - Please install that as well

3. **Developer Guide**
  - Please create a new branch any time modifying the code
  - Unless being permitted to do so

Check out this [Link](https://gorails.com/setup/osx/10.12-sierra) for more information for setting up environment
```bash
$ \curl -sSL https://get.rvm.io | bash -s stable    # get RVM
$ rvm requirements                                  # set up packages
$ rvm install 2.3.1                                 # install Ruby 2.3.1
$ gem install rails                                 # install Rails
```

##### Special notice for developing on Windows
- [Setting up Linux subsystem on Windows](https://gorails.com/setup/windows/10) is strongly recommended; after you've done so, simply repeat the setup procedure for Linux
- If you run into `"Error: Command 'rails' not recognized"` during generating controller pages, try
```bash
$ bundle install --binstubs                         # re-setup bundle
$ bundle config --delete bin                        # Re-configure
$ rake rails:update:bin                             # version control
$ git add bin
```

--------

## Post-Setup instructions

Run this line of code in your Rails console first (*notice: you can create whatever password you like for your root user*)
```Ruby
AdminUser.new(:email => "root@kicks4love.com", :password => "up to you", :password_confirmation => "up to you").save(:validate => false)
```
In order to predefine a root user so that you can login to `Kicks4Love Admin` with root user role.
