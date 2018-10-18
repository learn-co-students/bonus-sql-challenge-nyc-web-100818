# Write methods that return SQL queries for each part of the challeng here

def guest_with_most_appearances
  <<-SQL
    SELECT raw_guest_list, count(*)
    FROM daily_show_guests
    GROUP BY raw_guest_list
    ORDER BY 2 DESC
    LIMIT 1;
  SQL
end

def most_popular_profession_by_year
  <<-SQL
    SELECT
    		year,
    		googleknowlege_occupation as profession,
    		count(*) as total
    FROM daily_show_guests
    GROUP BY year, googleknowlege_occupation
    ORDER BY 1, 3 DESC;
  SQL
end

def most_popular_profession
  <<-SQL
    SELECT
    	googleknowlege_occupation as profession,
    	count(*) as total
    FROM daily_show_guests
    GROUP BY profession
    ORDER BY 2 DESC
    LIMIT 1;
  SQL
end

def how_many_bills
  <<-SQL
    SELECT
      count(*) as total
    FROM daily_show_guests
    WHERE raw_guest_list like '%Bill%';
  SQL
end

def patrick_stewart_shows
  <<-SQL
    SELECT
      show
    FROM daily_show_guests
    WHERE raw_guest_list like '%Patrick Stewart%';
  SQL
end

def year_with_most_guests
  <<-SQL
    SELECT
    		year,
    		count(*) as total
    FROM daily_show_guests
    GROUP BY year
    ORDER BY 2 DESC
    LIMIT 1;
  SQL
end

def most_popular_group_by_year
  <<-SQL
    SELECT
      group_,
      year,
      count(*) as total
    FROM daily_show_guests
    GROUP BY group_, year
    ORDER BY 2, 3 DESC;
  SQL
end
