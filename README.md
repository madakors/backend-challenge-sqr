## Sqr

Small application to access disbursements calculated for orders/merchants. See `CHALLENGE.md` for detailed description.

### How to install

#### With Docker
Simply run `docker-compose up` then wait until you see in the ouput that Rails has started.

To generate disbursements for the seeded data, run `docker-compose exec web rails disbursements:calculate` in a separate window

#### Without Docker
- Assuming you have Ruby and PostgreSQL installed, create a database user with `sqr`, password `sqr`
- Install gems with `bundle install`
- Run `bundle exec rails db:prepare` to handle the database
- Run `bundle exec rails db:seed` to seed the database with the sample data
- Run `bundle exec rails s -p 3000 -b 0.0.0.0` to run the application
- Run `bundle exec rails disbursements:calculate` to generate the disbursements for the seed data


### Accessing the API

Once the application is up and running, disbursements can be queried by accessing
http://localhost:3000/disbursements?week=1&year=2018&merchant_id=2

This URL should be accessible whether you're running it through Docker or not
