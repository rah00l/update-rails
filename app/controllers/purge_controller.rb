class PurgeController < ApplicationController
  layout 'adminlayout'
=begin  
def purgedata

	
	puts "From date -> #{params[:startdate]}"
	puts "To date -> #{params[:enddate]}"
	
	if params[:enddate].to_date >=params[:startdate].to_date
		puts "in if"
		@countcounter = Countercollection.count(
								:conditions=>["Date<='#{params[:enddate]}' and Date>='#{params[:startdate]}' and status=1"])
		@countclient=Clientdata.count( 
								:conditions=>["Date<='#{params[:enddate]}' and Date>='#{params[:startdate]}' and status=1"])
		@maxdateofclientdata = Clientdata.maximum(Date)
		@maxdateofcountercolletion = Countercollection.maximum(Date)
		puts "~~ #{@countcounter}~~~~~~ #{@maxdateofcountercolletion} ~~~~ #{@countclient}~~~ #{@maxdateofclientdata } ~~~~~~"	
#			if @countcounter.to_i>0 and @countclient.to_i>0
			begin
					
				@shopes=Countercollection.find(:all,:select => 'DISTINCT ShopName')
					for item in @shopes 
						p "............................."
						p 	item.ShopName
							@maxdate = Countercollection.find_by_sql("select max(date)as max from countercollections where shopname='#{item.ShopName}'")
					
							for a in @maxdate
									p @maxdate1=a.max
							end
					
						p "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
						Countercollection.find_by_sql("delete 
														from countercollections 
														where Date<='#{params[:enddate]}' and Date>='#{params[:startdate]}' 
														and Date!='#{@maxdate1}' and ShopName = '#{item.ShopName}'
														and status=1")
					
													
					end
												
												
												
			rescue
			end
			
			begin
					Clientdata.find_by_sql( "delete 
												from clientdatas 
												where Date<'#{params[:enddate]}' and Date>='#{params[:startdate]}' 
               and Date!='#{@maxdateofclientdata }'
												and status=1")
			rescue
			end
				
				@countcounter=Countercollection.count( 
								:conditions=>["Date<='#{params[:enddate]}' and Date>='#{params[:startdate]}' and status=1"])
      
				@countclient=Clientdata.count( 
								:conditions=>["Date<='#{params[:enddate]}' and Date>='#{params[:startdate]}' and status=1"])
      
				#	if @countcounter.to_i!=0 and @countclient.to_i!=0
				#		session[:msg]="Data purged successfully"
			#		else
			#			session[:msg]="Data purged unsuccessfully"
			#		end
		#		else
		#				session[:msg]="No data found for the selected dates"
		#	end
	else
		puts "in else"
		session[:msg]="Please select proper dates"
	end
    
    redirect_to :action=>'purgemain'
 
end
  
  def counterdata
  p "in purgecounterdata"

  
  puts "From date -> #{params[:startdate]}"
	puts "To date -> #{params[:enddate]}"
	
	if params[:enddate].to_date >=params[:startdate].to_date
		puts "in if"
		
		@countcounterdata = Counterdata.count(
								:conditions=>["Date<='#{params[:enddate]}' and Date>='#{params[:startdate]}'"])
		
		
		@maxdateofcounterdata = Counterdata.maximum(Date)
		
			puts "~~ #{@countcounterdata} ~~~~~~ #{@maxdateofcounterdata} ~~~~"	
			
			if @countcounterdata.to_i>0 
				begin
					Counterdata.find_by_sql("delete 
														from counterdatas 
														where Date<='#{params[:enddate]}' and Date>='#{params[:startdate]}' 
														and Date!='#{@maxdateofcounterdata}'")
				rescue
				end
				
				@countdata = Counterdata.count( 
								:conditions=>["Date<='#{params[:enddate]}' and Date>='#{params[:startdate]}' and Date!='#{@maxdateofcounterdata}'"])
      
				
					if @countdata.to_i==0 
						session[:msg]="Data purged successfully"
					else
						session[:msg]="Data purged unsuccessfully"
					end
    
			else
					session[:msg]="No data found for the selected dates"
			end
		
	else
		puts "in else"
		session[:msg]="Please select proper dates"
	end
    
    redirect_to :action=>'purgecounterdata'
	
	
	
  end
  
  def purgemachinedata
  p "in purgemachinedata"

  
  puts "From date -> #{params[:startdate]}"
	puts "To date -> #{params[:enddate]}"
	
	
  end
=end  

def purgedatafirst

puts "Purging for Countercollection ....."
		if params[:enddate].to_date >=params[:startdate].to_date
			
			
				#puts  @maxdatecc=Countercollection.minimum(:date)
				#puts  @mindatecc=Countercollection.maximum(:date)
			 
				#puts params[:enddate]
				#puts params[:startdate]
			
			
				#@countbcc = Countercollection.count(:conditions => "Date<='#{params[:enddate]}' and Date>='#{params[:startdate]}' and status=1")
													
				#puts @countbcc											
			
			@shopes=Countercollection.find(:all,:select => 'DISTINCT ShopName')
				for item in @shopes 
					#p "............................."
					#p 	item.ShopName
					@maxdate = Countercollection.find_by_sql("select max(date)as max 
														from countercollections 
														where shopname='#{item.ShopName}'
														and Date<='#{params[:enddate]}' and Date>='#{params[:startdate]}'")
						for a in @maxdate
							 @maxdate1=a.max
						end
				
					#@countcounter=Countercollection.count( 
					#			:conditions=>["Date<='#{params[:enddate]}' and Date>='#{params[:startdate]}' and status=1"])
      
					#@countclient=Clientdata.count( 
					begin
							
						Countercollection.find_by_sql("delete 
												from countercollections 
												where Date<='#{params[:enddate]}' and Date>='#{params[:startdate]}' 
												and Date!='#{@maxdate1}' and ShopName = '#{item.ShopName}'
												and status=1")
							
								
							
						rescue Exception => e
						#	p e.message
					end
					
					@countacc = Countercollection.count(:conditions => "Date<='#{params[:enddate]}' and Date>='#{params[:startdate]}' and status=1")
						
				
					
					
				end
              
		   # puts @countacc
              

			puts  "Purging for Clientdatas "
			
			#@countbcd = Clientdata.count(:conditions => "Date<='#{params[:enddate]}' and Date>='#{params[:startdate]}' and status=1")
			#puts @countbcd
				@shopes=Clientdata.find(:all,:select => 'DISTINCT ShopName')	
				for item in @shopes 
				
					
					@maxdate = Clientdata.find_by_sql("select max(date)as max 
																from clientdatas 
																where shopname='#{item.ShopName}'
																and Date<='#{params[:enddate]}' and Date>='#{params[:startdate]}'")
						for a in @maxdate
							 	item.ShopName
							 @maxdate1=a.max
						end
						
						begin
					
						Clientdata.find_by_sql( "delete 
												from clientdatas 
												where Date<='#{params[:enddate]}' and Date>='#{params[:startdate]}' 
												and Date!='#{@maxdate1}'and ShopName = '#{item.ShopName}'
												and status=1")
						
						rescue Exception => e
						#	p e.message
						end
					end	
			#@countacd = Clientdata.count(:conditions => "Date<='#{params[:enddate]}' and Date>='#{params[:startdate]}' and status=1")
			#puts @countacd
				session[:msg]="Purge Data Successfully "	
          else
				puts "in else"
				session[:msg]="Please select proper dates"
		end
	
		redirect_to :action=>'purgemain'							
												
			
    end
    
#####################################################################################################    


def Counterdata

puts "Purging for Counterdata ....."

		if params[:enddate].to_date >=params[:startdate].to_date
			
			@shopes=Counterdata.find(:all,:select => 'DISTINCT ShopName')
				
				for item in @shopes 
					#p "............................."
					#p 	item.ShopName
					@maxdate = Countercollection.find_by_sql("select max(date)as max 
																			from Counterdatas 
																			where shopname='#{item.ShopName}'
																			and Date<='#{params[:enddate]}' and Date>='#{params[:startdate]}'")
						
						for a in @maxdate
							 @maxdate1=a.max
						end
				
					begin
							Countercollection.find_by_sql("delete 
												from Counterdatas 
												where Date<='#{params[:enddate]}' and Date>='#{params[:startdate]}' 
												and Date!='#{@maxdate1}' and ShopName = '#{item.ShopName}'")
					rescue Exception => e
						#	p e.message
					end
				end
              
		    #puts @countacc
              	session[:msg]="Purge Data Successfully "	
          
		else
				puts "in else"
				session[:msg]="Please select proper dates"
		end
	
		redirect_to :action=>'purgecounterdata'							
	end
    



def Machinedata

puts "Purging for Machinedata ....."

		if params[:enddate].to_date >=params[:startdate].to_date
			@shopes=Machinedata.find(:all,:select => 'DISTINCT Shop_Name')
				for item in @shopes 
					#p "............................."
					puts 	item.Shop_Name
					@maxdate = Countercollection.find_by_sql("select max(TRANS_DATE)as max 
																			from Machinedatas 
																			where Shop_Name='#{item.Shop_Name}'
																			and TRANS_DATE<='#{params[:enddate]}' and TRANS_DATE>='#{params[:startdate]}'")
						
						for a in @maxdate
							p  @maxdate1=a.max
						end
				
						begin
							Countercollection.find_by_sql("delete 
												from Machinedatas 
												where TRANS_DATE<='#{params[:enddate]}' and TRANS_DATE>='#{params[:startdate]}' 
												and TRANS_DATE!='#{@maxdate1}' and Shop_Name = '#{item.Shop_Name}'")
						rescue Exception => e
						#	p e.message
						end
				end
              
				#puts @countacc
				session[:msg]="Purge Data Successfully "	
          else
				puts "in else"
				session[:msg]="Please select proper dates"
		end
	
		redirect_to :action=>'purgemachinedata'							
	end
end
