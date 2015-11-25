task :csv2authors => :environment do 
	require 'smarter_csv'
	csv_authors = SmarterCSV.process('./public/data-scientists.csv',{:col_sep => ",",:row_sep => "\r"})
	all_ids = Author.all.map{|au| au.elsevier_id}
	puts all_ids.to_s
	csv_authors.each do |author|
		if (!author[:elsevier_authid].nil?) && (!all_ids.include? author[:elsevier_authid].to_s) && (author[:elsevier_authid] != 999)
			new_author = Author.create(
				:first => author[:first_name], 
				:last => author[:last_name], 
				:elsevier_id => author[:elsevier_authid].to_s,
				:name => author[:first_name] + " " + author[:last_name]
			)
			new_author.update_attribute(:middle, author[:middle_initial]) if !author[:middle_initial].nil?
			puts author[:last_name] + " ... " + author[:elsevier_authid].to_s + " ... to DB"
		end
	end
end

