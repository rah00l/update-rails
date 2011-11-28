class ClientdatasController < ApplicationController
   layout 'adminlayout'
   require 'chronic'
   before_filter :login_required
   
   

  
  def showreadingmistakes
    
  session[:ttdate1]=params[:date1]
  #session[:ttdate2]=params[:date2]
  @session[:crname]=params[:machinedata][:ClusterName]
  end
  
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @clientdata_pages, @clientdatas = paginate :clientdatas, :per_page => 10
  end

  def show
    @clientdata = Clientdata.find(params[:id])
  end

  def new
    @clientdata = Clientdata.new
  end

#METHOD WHILE CREATING A NEW clientdata
def create
  #@count
    begin
    
    @time=Time.now().strftime("%H:%M:%S")
    @stime=@time.split(":")
    @totalsec=@stime[0].to_i*3600+@stime[1].to_i*60+@stime[2].to_i
    
     render :update do |page|
      
    if params[:clientdata][:ScreenIN]==""
        #flash[:notice]="Screen IN can't be empty"
        page.redirect_to url_for(:controller=>'clientdatas',:action=>'new')
    else
        if((params[:clientdata][:ShopName]==nil or params[:clientdata][:ShopName]=="") and @session[:shopname]!=nil)
            puts "in if"
            params[:clientdata][:ShopName]=@session[:shopname]
            puts params[:clientdata][:ShopName]
        end
        
        if((params[:clientdata][:GroupID]==nil or params[:clientdata][:GroupID]=="") and @session[:Groupid]!=nil)
            params[:clientdata][:GroupID]=@session[:Groupid]
             
         end
         
         
         if((params[:clientdata][:MachineNo]==nil or params[:clientdata][:MachineNo]=="") and @session[:MachineNo]!=nil)
            params[:clientdata][:MachineNo]=@session[:MachineNo]
             
         end
         if((params[:clientdata][:MachineName]==nil or params[:clientdata][:MachineName]=="") and @session[:MachineName]!=nil)
            params[:clientdata][:MachineName]=@session[:MachineName]
             
         end
        @count=Machine.count(:conditions=>["GroupID=? and ShopName=? and MachineNo=? and MachineName=?",params[:clientdata][:GroupID],params[:clientdata][:ShopName],params[:clientdata][:MachineNo],params[:clientdata][:MachineName]])  
        #puts "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&7"
        #puts @count
        #puts "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&7"
        if @count.to_i!=0
          @date=Date.parse(params[:clientdata][:Date])
          @duprecord=Clientdata.find_first(["ShopName=? and GroupID=? and MachineNo=?  and  date=?",params[:clientdata][:ShopName],params[:clientdata][:GroupID],params[:clientdata][:MachineNo],@date])
          #@duprecord=Clientdata.find_first(["ShopName=? and GroupID=? and MachineNo=? and MachineName=? and  date=?",params[:clientdata][:ShopName],params[:clientdata][:GroupID],params[:clientdata][:MachineNo],params[:clientdata][:MachineName],@date])
        
          if(@duprecord!=nil)
            #puts "in dupliocate"
            #puts @time
            #@saverecord=Clientdata.find_first(["ShopName=? and GroupID=? and MachineNo=? and MachineName=? and  date=? and Created_Time=?",params[:clientdata][:ShopName],params[:clientdata][:GroupID],params[:clientdata][:MachineNo],params[:clientdata][:MachineName],@date,@time])
           
            #if(@saverecord==nil)
                #page.redirect_to url_for(:controller=>'clientdatas',:action=>'confirmduplicate')
            #else
            #puts "in saverecord else"
             #@dtime=@saverecord.Created_Time.strftime("%H:%M:%S").split(":")
             #@totalsecd=@dtime[0].to_i*3600+@dtime[1].to_i*60+@dtime[2].to_i
             #puts @totalsecd
             #puts @totalsec.to_i-@totalsecd.to_i
              #if((@totalsec.to_i-@totalsecd.to_i).to_i<=30 or (@totalsec.to_i-@totalsecd.to_i).to_i>=0)
                #page.redirect_to url_for(:controller=>'clientdatas',:action=>'confirmdata')
            
              #else
              #page.redirect_to url_for(:controller=>'clientdatas',:action=>'confirmduplicate')
              #end
              #end
              @dtime=@duprecord.Created_Time.strftime("%H:%M:%S").split(":")
              @totalsecd=@dtime[0].to_i*3600+@dtime[1].to_i*60+@dtime[2].to_i
              if( (@totalsec.to_i-@totalsecd.to_i).to_i<=1 )
                  page.redirect_to url_for(:controller=>'clientdatas',:action=>'new')
              else
                  page.redirect_to url_for(:controller=>'clientdatas',:action=>'confirmduplicate')
              end
            else
              @cluster=Shop.find_first(["ShopName=?",params[:clientdata][:ShopName]])
              params[:clientdata][:ClusterName]=@cluster.ClusterName
              params[:clientdata][:Created_Time]=@time
              @clientdata = Clientdata.new(params[:clientdata])
              puts "gasfgsf"
              @mno=@session[:MachineNo]
              puts @mno.gsub!(/\D/,'') 
              page << "document.getElementById('save').disabled = true;"
              page << "document.getElementById('save').style.visibility = 'hidden'"
              if @clientdata.save
               
                #flash[:confirm] = '<font color=green size=4><b>ENTRY WAS SUCCESSFULLY CREATED.</b></font>'
                #page.alert("save data")
                
                @session[:MachineNo]=nil
                @session[:MachineName]=nil
               
                page.redirect_to url_for(:controller=>'clientdatas',:action=>'new')
              else
                page.redirect_to url_for(:controller=>'clientdatas',:action=>'new')
              end
            end
          else
            page.redirect_to url_for(:controller=>'clientdatas',:action=>'new')
          end
    end
      
    end
    rescue Exception=>ex
        puts ex.message()
         flash[:notice]=nil
         flash[:confirm] =nil
    end
end


def update_machine
    begin
    
    @session[:MachineNo]=nil
     @session[:MachineName]=nil
    puts params[:GroupID]
      @session[:Groupid]=params[:GroupID]
      render :update do |page|
	  page.replace_html 'MachineNodiv', :partial => 'machine'
      page.replace_html 'MachineNamediv', :partial => 'machinename'
      page << "document.getElementById('clientdata_MachineNo').focus();"
      end 
  
    rescue Exception=>ex
        puts ex.message()
    end
end 
def update_machineprev
    begin
    
    @session[:MachineNo]=nil
    puts params[:GroupID]
      @session[:Groupid]=params[:GroupID]
      render :update do |page|
	  page.replace_html 'MachineNodiv', :partial => 'machineprev'
      page.replace_html 'MachineNamediv', :partial => 'machinenameprev'
      page << "document.getElementById('clientdata_MachineNo').focus();"
      end 
  
    rescue Exception=>ex
        puts ex.message()
    end
end 



def update_machinename
begin

puts "in update"
   puts params[:MachineNo]
   puts @session[:mcno]
    if(params[:MachineNo]!=nil)
        @machinename=Machine.find_first(["ShopName=? and GroupID=? and MachineNo=?",@session[:shopname],@session[:Groupid],params[:MachineNo]])
    else
        @machinename=Machine.find_first(["ShopName=? and GroupID=? and MachineNo=?",@session[:shopname],@session[:Groupid],@session[:mcno]])
    end
    
     
        
        
        
    if(@machinename==nil)
    render :update do |page|
    
    page.alert("No Machine Found")
    @session[:mcno]=nil
    page << "document.getElementById('clientdata_MachineNo').options[0].value='';"
    page << "document.getElementById('clientdata_MachineNo').options[0].text='';"
    page << "document.getElementById('clientdata_MachineNo').focus();"
    end

    else 
     
    render :update do |page|        
    if(params[:MachineNo]!=nil)
    @session[:MachineNo]=params[:MachineNo]
    
       page << "document.getElementById('clientdata_MachineNo').options[0].value='';"
       page << "document.getElementById('clientdata_MachineNo').options[0].text='';"
    else
    @session[:MachineNo]=@session[:mcno]
    end
        @session[:MachineName]=@machinename.MachineName
       
        puts "VALUE"
        puts @session[:MachineName]
        puts @session[:mcno]
        
        page.replace_html 'MachineNamediv', :partial => 'machinename'
        page << "document.getElementById('clientdata_ScreenIN').focus();"
    end
    end

    rescue Exception=>ex
        puts ex.message
    end
    #@session[:mcno]=nil
  end 
  
  
def showmc
    @session[:mcno]=params[:MachineNo]
end

########CHECK FOR MACHINENO IF CLICKED ON SCREEN IN#####################
def checkmachineno
    if(params[:MachineNo]!=nil)
        @machinename=Machine.find_first(["ShopName=? and GroupID=? and MachineNo=?",@session[:shopname],@session[:Groupid],params[:MachineNo]])
    else
        @machinename=Machine.find_first(["ShopName=? and GroupID=? and MachineNo=?",@session[:shopname],@session[:Groupid],@session[:mcno]])
    end
    if(@machinename==nil)
    render :update do |page|
    page.alert("No Machine Found")
    @session[:mcno]=nil
    page << "document.getElementById('clientdata_MachineNo').options[0].value='';"
    page << "document.getElementById('clientdata_MachineNo').options[0].text='';"
    page << "document.getElementById('clientdata_MachineNo').focus();"
    #page << "document.getElementById('clientdata_ScreenIN').value='';"
    end

    else 
    end
end


def update_machinenameprev
    begin
    p "in update mcname"
    p @session[:shopname]
    @machinename=Machine.find_first(["ShopName=? and MachineNo=?",@session[:shopname],params[:MachineNo]])
    @session[:MachineNo]=params[:MachineNo]
    @session[:MachineName]=@machinename.MachineName
    render :update do |page|
	  page.replace_html 'MachineNamediv', :partial => 'machinenameprev'
    page << "document.getElementById('clientdata_ScreenIN').focus();"
    end
    
    rescue Exception=>ex
        puts ex.message
    end
end 

def getGroup
    begin
    
    
    @session[:Groupid]=nil
     @session[:MachineName]=nil
    puts "IN GROUP1111"
    puts params[:ShopName]
     puts @session[:shopname]
     puts "***************"
    if(params[:ShopName]!="" )
    #@session[:shopname]=params[:ShopName]
        puts "in if"
      @session[:shopname]=params[:ShopName]
    end
    puts @session[:shopname]
    render :update do |page|
	  page.replace_html 'KeyIDdiv', :partial => 'group'
      #page.replace_html 'shopnamediv', :partial => 'shopname'
      page.replace_html 'MachineNodiv', :partial => 'machine'
      page.replace_html 'MachineNamediv', :partial => 'machinename'
       page << "document.getElementById('clientdata_GroupID').focus();"
    end
rescue Exception=>exc
     puts exc.message
end
end


def getGroupprev
    begin
    puts "********************************"
    if (params[:ShopName]=='SHOP1')
        puts "VLAUE FOUND"
    end
    
    @session[:Groupid]=nil
    puts "IN GROUP1111"
    puts params[:ShopName]
     puts @session[:shopname]
     puts "***************"
    if(params[:ShopName]!="" )
    #@session[:shopname]=params[:ShopName]
        puts "in if"
      @session[:shopname]=params[:ShopName]
    end
    puts @session[:shopname]
    render :update do |page|
	  page.replace_html 'KeyIDdiv', :partial => 'groupprev'
      #page.replace_html 'shopnamediv', :partial => 'shopname'
      page.replace_html 'MachineNodiv', :partial => 'machineprev'
      page.replace_html 'MachineNamediv', :partial => 'machinenameprev'
       page << "document.getElementById('clientdata_GroupID').focus();"
    end
rescue Exception=>exc
     puts exc.message
end
end



  def edit
     @clientdata=Clientdata.find(:first,:conditions=>["ShopName=? and GroupID=? and MachineNo=? and Date='#{@session['date']}'",@session[:shopname],@session[:Groupid],@session[:MachineNo]])        
        puts @clientdata.id
        @clientdata = Clientdata.find(@clientdata.id)
      
      
    #@clientdata = Clientdata.find(params[:id])
  end


  def update
    @clientdata1=Clientdata.find(:first,:conditions=>["ShopName=? and GroupID=? and MachineName=? and MachineNo=? and Date='#{@session['date']}'",@session[:shopname],@session[:Groupid],@session[:MachineName],@session[:MachineNo]])        
    @clientdata = Clientdata.find(@clientdata1.id)
    puts "aasasas"
    puts params[:clientdata][:MeterOUT]
        if(params[:clientdata][:ScreenIN]=="" or params[:clientdata][:ScreenOUT]=="" or params[:clientdata][:MeterIN]=="" or params[:clientdata][:MeterOUT]=="")
            render :update do |page|
        page.alert("PLEASE ENTER DATA")
            end
        else
        if @clientdata.update_attributes(params[:clientdata])
        #flash[:notice] = 'Clientdata was successfully updated.'
        # render :action => 'edit'
        render :update do |page|
        page.alert("ENTRY UPDATED SUCCESSFULLY")
        page.redirect_to url_for(:controller=>'clientdatas',:action=>'new')
        end
        end
        end
  end

  def destroy
    puts "in destroy"
    @clientdata=Clientdata.find(:first,:conditions=>["ShopName=? and GroupID=? and MachineName=? and MachineNo=? and Date='#{@session['date']}'",@session[:shopname],@session[:Groupid],@session[:MachineName],@session[:MachineNo]])        
    Clientdata.find(@clientdata.id).destroy
    
	render :update do |page|
        page.alert("ENTRY DELETED SUCCESSFULLY")
        page.redirect_to url_for(:controller=>'clientdatas',:action=>'new')
        end
end


def backtolist
       
    @session['date']=Date.parse(params[:clientdata][:Date])
     
    if(params[:clientdata][:MachineNo]==nil or params[:clientdata][:MachineNo]=="")
    #session[:errmsg]="PLEASE SELECT MACHINENO"
    render :update do |page|
    page.alert("PLEASE SELECT MACHINENO")
    page << "document.getElementById('clientdata_MachineNo').focus();"
    #page.redirect_to url_for(:controller=>'clientdatas', :action=>'new')
    end  
    else
        puts "in else"
        puts @session['date']
        puts @session[:shopname]
        puts @session[:Groupid]
        puts @session[:MachineName]
        puts params[:clientdata][:MachineNo]
        
        @clientdata=Clientdata.find(:first,:conditions=>["ShopName=? and GroupID=? and MachineNo=? and Date='#{@session['date']}'",@session[:shopname],@session[:Groupid],params[:clientdata][:MachineNo]])        
        
        if(@clientdata!=nil)
        @clientdata = Clientdata.find(@clientdata.id)
        puts "**********************************"
        puts @clientdata.ShopName
        puts @session['date']
        @abc = Countercollection.find_by_sql("select count(*) as countcheck from countercollections where shopname='#{@clientdata.ShopName}' and date='#{@session['date']}'")
        puts @abc[0].countcheck
			if @abc[0].countcheck.to_i == 0
				render :update do |page|
					page.redirect_to url_for(:controller=>'clientdatas', :action=>'edit')
				end  
			else
				#session[:errmsg]="NO RECORD FOUND FOR SELECTED MACHINE"
				render :update do |page|
					page.alert("DATA ALREADY SUBMITED CAN NOT EDIT")
				# page.redirect_to url_for(:controller=>'clientdatas', :action=>'new')
				end 	
			end
        else
            #session[:errmsg]="NO RECORD FOUND FOR SELECTED MACHINE"
            render :update do |page|
            page.alert("NO RECORD FOUND FOR SELECTED MACHINE")
           # page.redirect_to url_for(:controller=>'clientdatas', :action=>'new')
    end 
        end
    end
  end




def canceladd
    render :update do |page|
    page.redirect_to url_for(:controller=>'clientdatas', :action=>'new')
    end
end



#SHORT REASON CODE FOR ENTRING THE SHORTS FOR SPECIFIC MACHINE
def checkshort
    begin
        puts "in short---------------------------------------------------------------------------------------"
        puts params[:clientdata][:MachineNo]
            
            puts @session[:shopname]
            if(params[:clientdata][:ShopName]=="" and @session[:shopname]==nil) #IF SHOPID NOT SELECTED THEN 
                puts "in ERROR"
                session[:errmsg]="Please select ShopID"
                
                render :update do |page|
                    page.redirect_to url_for(:controller=>'clientdatas', :action=>'new')
                end 
            elsif(params[:clientdata][:GroupID]=="" and @session[:Groupid]==nil)#IF SHOPID NOT SELECTED THEN 
                puts "in ERROR"
                session[:errmsg]="Please select GroupID"
                
                render :update do |page|
                    page.redirect_to url_for(:controller=>'clientdatas', :action=>'new')
                end 
            elsif(params[:clientdata][:MachineName]=="" or @session[:MachineNo]==nil or params[:clientdata][:MachineNo]=="" ) #IF SHOPID NOT SELECTED THEN 
                puts "in ERROR"
                session[:errmsg]="Please Select MachineNo"
                
                render :update do |page|
                    page.redirect_to url_for(:controller=>'clientdatas', :action=>'new')
                end  
            else
                puts "DATA IS"
                puts @session[:shopname]
                puts @session[:Groupid]
                puts @session[:MachineName]
                
                
                puts params[:clientdata][:ShopName]
                if(params[:clientdata][:GroupID]==nil or  params[:clientdata][:GroupID]=="")
                    @session['shortgroupid']=@session[:Groupid]
                else              
                @session['shortgroupid']=params[:clientdata][:GroupID]
                end
                
                if(params[:clientdata][:MachineName]==nil or params[:clientdata][:MachineName]=="")
                    @session['shortmachinename']=@session[:MachineName]
                else              
                 @session['shortmachinename']=params[:clientdata][:MachineName]
                end
                
                 if(params[:clientdata][:ShopName]=="" or params[:clientdata][:ShopName]==nil)
                    @session['shortshop']=@session[:shopname]
                else              
                @session['shortshop']=params[:clientdata][:ShopName]
              end
              puts "---------------------------------------"
               puts "short data"
               puts @session['shortshop']
               puts @session['shortgroupid']
               puts @session['shortmachinename']
               @session['shortmachineno']=params[:clientdata][:MachineNo]
               #@mname=Machine.find(:first,:conditions=>['ShopName=? and GroupID=? and MachineNo=?',@session['shortshop'],@session['shortgroupid'],params[:clientdata][:MachineNo]])
               
               
                @session['shortdate']=Date.parse(params[:clientdata][:Date])
                 @date=Date.parse(params[:clientdata][:Date])
                 puts @date
               
                #@s=Clientdata.find_first(["ShopName=? and GroupID=? and MachineName=? and MachineNo=? and Date=?",@session['shortshop'],@session['shortgroupid'],@session['shortmachinename'],@session['shortmachineno'],@date])        
                #@s=Clientdata.find_first(["ShopName=? and GroupID=? and MachineNo=? and Date=?",@session['shortshop'],@session['shortgroupid'],@session['shortmachineno'],@date])        
                @s=Clientdata.find_first(["ShopName=? and GroupID=? and MachineNo=? and Date=?",@session['shortshop'],@session['shortgroupid'],@session['shortmachineno'],@date])        
                puts @s
                puts "---------------------------------------"
=begin                
                fp=File.new("test.txt",'w')
                fp.write(@session['shortshop'])
                fp.write("\n")
                fp.write(@session['shortgroupid'])
                fp.write("\n")
                #fp.write(@mname.MachineName)
                #fp.write("\n")
                fp.write(@date)
                fp.write("\n")
                fp.write(@s)
                fp.write("\n")
                fp.close()
=end                
                    if(@s!=nil)
                    
                        puts "CLIENTDATAS SHORT IS "
                        #puts @s.Machineshort
					p @session['date']
					@abc = Countercollection.find_by_sql("select count(*) as countcheck from countercollections where shopname='#{@session['shortshop']}' and date='#{@session['date']}'")
					puts @abc[0].countcheck
					if @abc[0].countcheck.to_i == 0    
						render :update do |page|
							page.redirect_to url_for(:controller=>'clientdatas', :action=>'short')
						end 
					else
							#session[:errmsg]="NO RECORD FOUND FOR SELECTED MACHINE"
						render :update do |page|
							page.alert("DATA ALREADY SUBMITED CAN NOT EDIT")
							# page.redirect_to url_for(:controller=>'clientdatas', :action=>'new')
						end 	
					end	
                    else
                        #session[:errmsg]="Please Enter Screen Details for Selected Machine No."
                        session[:errmsg]="Reading Missing in Data Entry Screen."
                
                    render :update do |page|
                        page.redirect_to url_for(:controller=>'clientdatas', :action=>'new')
                    end  
                    end
                    
            end
    rescue Exception=>ex
    puts ex.message
    end
    
end



def saveshort
    begin
    p "IN SAVESHORT"
    puts @session['shortshop']
     
     @s=Clientdata.find_first(["ShopName=? and GroupID=? and MachineNo=? and MachineName=? and Date=?",@session['shortshop'],@session['shortgroupid'],@session['shortmachineno'],@session['shortmachinename'],@session['shortdate']])    
                            if(@s!=nil)
                                if(params[:clientdata][:Machineshort]==nil)
                                   session[:errmsg]="Please select ShopID"
                                redirect_to :controller=>'clientdatas',:action => 'short'
                                #render :update do |page|
                                    #page.redirect_to url_for(:controller=>'clientdatas', :action=>'short')
                                #end
                                elsif(params[:clientdata][:Shortreason]==nil)
                                   session[:errmsg]="Please select ShopID"
                                p "nil value for reason"
                                render :update do |page|
                                    page.redirect_to url_for(:controller=>'clientdatas', :action=>'short')
                                end
                                #redirect_to :controller=>'clientdatas',:action => 'short'
                                else
                                    
                                puts "in else"
                                begin
                                @short=params[:clientdata][:Machineshort].to_i/10
                                
                                @s.Machineshort="-#{@short}"
                                @s.Shortreason=params[:clientdata][:Shortreason]
                                @s.save
                                rescue Exception=>ex
                                puts ex.message()
                                end
                                #render :update do |page|
                                    #page.redirect_to url_for(:controller=>'clientdatas',:action => 'new')
                                #end 
                                redirect_to :controller=>'clientdatas',:action => 'new'
                                end
                            else
                                 render :update do |page|
                                    page.alert("Please Enter its details first")
                                    page.redirect_to url_for(:controller=>'clientdatas', :action=>'new')
                                end
                            end
                            
        rescue Exception=>ex
            puts ex.message
        end
end


def entrydata
    render :update do |page|
	  page.redirect_to url_for( :action=>'new')
    end  
end




#COUNTERCOLLECTION CODE FOR CHECKING WHETHER ALL ENTRIES HAS BEEN FILLED
#FOR THAT SHOP IF YES MAY MOVE TO COUNTER COLLECTION ADDING SCREEN
def checkcounter
    begin

        
        
        if (params[:clientdata][:ShopName]=="" or params[:clientdata][:ShopName]==nil) and @session[:shopname]==nil #IF SHOPID NOT SELECTED THEN 
            session[:errmsg]="Please select ShopID"
            render :update do |page|
            page.redirect_to url_for(:controller=>'clientdatas', :action=>'new')
            end 
        else
            if(params[:clientdata][:ShopName]=="" and @session[:shopname]!=nil)
                params[:clientdata][:ShopName]=@session[:shopname]
            end
            ########CHECK MACHINE COUNT ###########################
            @mcount=Machine.count(["ShopName=?",params[:clientdata][:ShopName]]) #MACHINE COUNT WITH GIVEN SHOPID
            @date=Date.parse(params[:clientdata][:Date])
            
            ###############CHECK FOR DUP RECORD##################
                    #@dupcheck=Clientdata.find_by_select("select count(MachineNo) as mcount,Machineno from clientdatas where date='#{date}' and ShopName='#{params[:clientdata][:shopname]}' group by MachineNo having count(MachineNo)>1")
                    
            ###############END DATA##############################
            
            
            ########CHECK CLIENTDATA ENTRY COUNT#####################
            #@c =Clientdata.count(["ShopName=? and Date=? and status=0",params[:clientdata][:ShopName],"#{@date}"])  #ENTRY COUNT WITH GIVEN SHOPID AND DATE
            @c=Clientdata.find_by_sql("select count(distinct Machineno) as mccount from clientdatas where ShopName='#{params[:clientdata][:ShopName]}' and Date='#{@date}' and status=0")
            puts @c[0].mccount
            puts "#########################################"
            
            
                puts "mcount#{@mcount}"
                puts "entrycount#{@c[0].mccount}"
                #########CHECK WHETHER MACHINE COUNT AND ENTRY COUNT MATCHING OR NOT
                if(@mcount==@c[0].mccount.to_i and @mcount!=0 and @c[0].mccount.to_i!=0)
                    
                    #########IF DATA IS ENTRED ALL THEN FOR RECORD PRESENT IN PREVIOUS RECORD OR NOT
                    @pcount=Previousrecord.count(["ShopName=?",params[:clientdata][:ShopName]])  #PREVIOUSRECORD COUNT WITH SELECTED SHOPID
                    puts @pcount
                    @session['shop']=params[:clientdata][:ShopName]
                    @session['date']=params[:clientdata][:Date]
                    
                    if(@pcount==0)
                        @session['shop']=params[:clientdata][:ShopName]
                        @session['date']=params[:clientdata][:Date]
                        render :update do |page|
                            page.redirect_to url_for(:controller=>'previousrecords', :action=>'new')
                        end 
                    else
                        
                        #####CHECK FOR COUNTER COLLECTION COUNT #######################
                        @date=Date.parse(params[:clientdata][:Date])
                        @ccount=Countercollection.count(["ShopName=? and Date=?",params[:clientdata][:ShopName],@date])
                       
                        
                        if(@ccount==0)
                        ##COUNTERCOLLECTION ENTRYING NEW ENTRY  
                        
=begin                           
                            @p=Previousrecord.find_first(["ShopName=?",params[:clientdata][:ShopName]])    
                            puts "values for COLUNTER"
                            puts @p.Xcredit
                            puts @p.Xcash
                            puts @date
                            @session['credit']=@p.Xcredit
                            @session['cash']=@p.Xcash
                            #@session['obal']=@p.Xcredit.to_i+@p.Xcash.to_i
                            @session['obal']=@p.Openingbal
=end
                            
                            puts "in count"
                            #############GETTING CASH AND CREDIT FOR THE SELECTED SHOP AND SHOWING OB ON SELECTED DATE
                            @p1=Countercollection.find_by_sql("select Cash as 'cash',Credit as 'credit' from countercollections where Date<'#{@date}'and ShopName='#{params[:clientdata][:ShopName]}' order by Date desc limit 1")
                            #@p111=Countercollection.find(:all,:conditions=>["Date<'#{@date}' and ShopName='#{params[:clientdata][:ShopName]}'"],:order=>Date,:limit=>1)
                            puts @p1[0]
                            if(@p1[0]!=nil)
                                puts "in if"
                               @session['credit']=@p1[0].credit
                               @session['cash']=@p1[0].cash
                               @session['obal']=@p1[0].credit.to_i+@p1[0].cash.to_i
                            else
                                @p=Previousrecord.find_first(["ShopName=?",params[:clientdata][:ShopName]])    
                            
                                    @session['credit']=@p.Xcredit
                                    @session['cash']=@p.Xcash
                                    @session['obal']=@p.Xcredit.to_i+@p.Xcash.to_i
                            end
                            
                            puts @session['cash']
                            puts @session['credit']
                            
                            @session['date']=@date
                            @session['sname']=params[:clientdata][:ShopName]  
                              
                            render :update do |page|
                                page.redirect_to url_for(:controller=>'countercollections', :action=>'new')
                            end 
                           
                        else
                            ###########COUNTER COLLECTION EDITING##################################
                                @date=Date.parse(params[:clientdata][:Date])
                                @counter=Countercollection.find_first(["ShopName=? and Date=?",params[:clientdata][:ShopName],@date])
                                                                
                                @session['sname']=@counter.ShopName
                                 
                                @p=Countercollection.find_by_sql("select Cash as 'cash',Credit as 'credit' from countercollections where Date<'#{@date}'and ShopName='#{params[:clientdata][:ShopName]}' order by Date desc limit 1")
                                if(@p[0]!=nil)
                                    puts "in IFFFFFFFFFFF"
                                @session['credit']=@p[0].credit
                                @session['cash']=@p[0].cash
                                @session['obal']=@p[0].credit.to_i+@p[0].cash.to_i
                                else
                                    puts "in ELSE ******************************"
                                @p=Previousrecord.find_first(["ShopName=?",params[:clientdata][:ShopName]])    
                            
                                    @session['credit']=@p.Xcredit
                                    @session['cash']=@p.Xcash
                                    @session['obal']=@p.Xcredit.to_i+@p.Xcash.to_i
                                end
                                    puts 
                                 #@session['obal']=@counter.Openingbal
                                 #@session['credit']=@counter.Credit
                                 #@session['cash']=@counter.Cash
                                @session['total1']=@counter.Cash.to_i+@counter.Exp.to_i+@counter.HC.to_i+@counter.Credit.to_i+@counter.Short_Ext.to_i
                                @session['total2']=@counter.Openingbal.to_i+@counter.KEY1.to_i+@counter.KEY2.to_i+@counter.KEY3.to_i+@counter.KEY4+@counter.Outstanding.to_i
                                @session['id']=@counter.id
puts "*********************************************************>>>>	"
puts @session['shop']
puts  @date
p ">>--------------->"
						@abc = Countercollection.find_by_sql("select count(*) as countcheck from countercollections where shopname='#{@session['shop']}' and date='#{@date}'")
						puts @abc[0].countcheck
						if @abc[0].countcheck.to_i == 0 
                                render :update do |page|
                                    page.redirect_to url_for(:controller=>'countercollections', :action=>'edit',:id=>@counter.id)
						 end 
						else
							#session[:errmsg]="NO RECORD FOUND FOR SELECTED MACHINE"
						render :update do |page|
							page.alert("DATA ALREADY SUBMITED CAN NOT EDIT")
							# page.redirect_to url_for(:controller=>'clientdatas', :action=>'new')
						end 	
					end			
						 
                        end
                    end
                else
                    if(@mcount==0 and @c==0)
                        session[:errmsg]="NO MACHINES MAPPED TO THE SELECTED SHOP"
                        render :update do |page|
                            page.redirect_to url_for(:controller=>'clientdatas', :action=>'new')
                        end 
                    else
					
                        render :update do |page|
                        page.redirect_to url_for(:action=>'confirm')
                        end 
                    end
                end
            end 
        rescue Exception=>ex
            puts ex.message 
        end
    end
 
def checkcounter111
          begin
                puts "COUNTER"
                puts @session[:shopname]
                 puts params[:clientdata][:ShopName]
                puts params[:clientdata][:Date]
                #params[:clientdata][:ShopName]=@session['shop']
                
                if (params[:clientdata][:ShopName]=="" or params[:clientdata][:ShopName]==nil) and @session[:shopname]==nil #IF SHOPID NOT SELECTED THEN 
                puts "in ERROR"
                session[:errmsg]="Please select ShopID"
                
                render :update do |page|
                    page.redirect_to url_for(:controller=>'clientdatas', :action=>'new')
                end 
            else
                puts "in else"
                puts params[:clientdata][:ShopName]
                puts params[:clientdata][:Date]
                if(params[:clientdata][:ShopName]=="" and @session[:shopname]!=nil)
                   params[:clientdata][:ShopName]=@session[:shopname]
                   puts "in if@@@@@@@@@@"
                end
        @mcount=Machine.count(["ShopName=?",params[:clientdata][:ShopName]]) #MACHINE COUNT WITH GIVEN SHOPID
        @date=Date.parse(params[:clientdata][:Date])
        puts @date
        puts params[:clientdata][:ShopName]
        @c =Clientdata.count(["ShopName=? and Date=? ",params[:clientdata][:ShopName],"#{@date}"])  #ENTRY COUNT WITH GIVEN SHOPID AND DATE
                puts "mcount#{@mcount}"
                puts "entrycount#{@c}"
                if(@mcount==@c and @mcount!=0 and @c!=0)
                    
                        @date=Date.parse(params[:clientdata][:Date])
                        @ccount=Countercollection.count(["ShopName=? and Date=?",params[:clientdata][:ShopName],@date])
                        puts "Counter count"
                        puts @ccount
                       if(@ccount==0)
                            @p=Shop.find_first(["ShopName=?",params[:clientdata][:ShopName]])    
                            puts "values for COLUNTER"
                            puts @p.Credit
                            puts @p.Cash
                            puts @date
                             @session['shop']=@p.ShopName
                            @session['credit']=@p.Credit
                            @session['cash']=@p.Cash
                            #@session['obal']=@p.Xcredit.to_i+@p.Xcash.to_i
                            @session['obal']=@p.OpeningBal
                            @session['date']=@date
                              @session['sname']=params[:clientdata][:ShopName]  
                            render :update do |page|
                                page.redirect_to url_for(:controller=>'countercollections', :action=>'new')
                            end 
                           
                        else
                            @date=Date.parse(params[:clientdata][:Date])
                                 
                                 @counter=Countercollection.find_first(["ShopName=? and Date=?",params[:clientdata][:ShopName],@date])
                                 
                                 puts "CODE FOR EDITING COUNTER COLLECTION"
                                 @session['sname']=@counter.ShopName
                                 @session['obal']=@counter.Openingbal
                                 @session['credit']=@counter.Credit
                                 @session['cash']=@counter.Cash
                                 @session['total1']=@counter.Cash.to_i+@counter.Exp.to_i+@counter.HC.to_i+@counter.Credit.to_i+@counter.Short_Ext.to_i
                                 @session['total2']=@counter.Openingbal.to_i+@counter.KEY1.to_i+@counter.KEY2.to_i+@counter.KEY3.to_i+@counter.KEY4+@counter.Outstanding.to_i
                              
                                    @session['id']=@counter.id
                                 render :update do |page|
                                    page.redirect_to url_for(:controller=>'countercollections', :action=>'edit',:id=>@counter.id)
                            end 
                       
                    end
                else
                    if(@mcount==0 and @c==0)
                        session[:errmsg]="NO MACHINES MAPPED TO THE SELECTED SHOP"
                        render :update do |page|
                            page.redirect_to url_for(:controller=>'clientdatas', :action=>'new')
                        end 
                    else
                    
                    render :update do |page|
                        page.redirect_to url_for(:action=>'confirm')
                    end 
                    end
            end
        end 
        rescue Exception=>ex
            puts ex.message 
        end
    end
 

def missingrecordslist
    puts "missing records"
    puts params[:clientdata][:ShopName]
    #puts params[:clientdata_Date]
    puts @session[:shopname]
    if(params[:clientdata][:ShopName]==""  and @session[:shopname]==nil)
        puts "in if"
        session[:errmsg]="Please select ShopName"
            render :update do |page|
                page.redirect_to url_for(:controller=>'clientdatas', :action=>'new')
            end 
    else
        if(params[:clientdata][:ShopName]=="")
            @session['shop']=@session[:shopname]
        else
        @session['shop']=params[:clientdata][:ShopName]
        end
        @session['date']=params[:clientdata][:Date]
        @session['date']=Date.parse(@session['date'])
        puts 
        render :update do |page|
            page.redirect_to url_for(:controller=>'clientdatas', :action=>'missingrecords')
        end
    end 
end

 def cancelentry
    puts "@@@@@@@@@@@@@@@@@@@@@@@@@"
    puts @session[:shopname]
    puts @session[:Groupid]
    puts @session[:MachineNo]
    puts "#####################"
    render :update do |page|
    page.redirect_to url_for(:controller=>'clientdatas', :action=>'new')
    end
end

def showdata
    #session[:datetrue]="true"
    p "showdata"
    puts params[:datevalue]
    session[:testval]=params[:datevalue]
    #session[:dateval]=params[:datevalue]
    render :update do |page|
        page.replace_html('griddisp',:partial=>'edetails')
    end
end
   
#DATA WILL BE SEND TO SERVER AND DUMPPED IN .SQL BACKUP FILE
def createdata
  #debugger
   # puts @session['uname']
  #puts @session['pass']
  	@result=User.login_type(@session['uname'],@session['pass'])
    #  puts "---------------- #{@result.usertype} --------------------------------------"
                    
    begin
        render :update do |page|
        #page << "document.getElementById('aux_div').style.visibility = 'visible'"
        
        ## ARRAY OF SHOPS WHOSE DATA HAS TO BE SENT
        shopval=params[:clientdatas][:ShopName]
        for i in 0..shopval.length-1
        #puts shopval[i]
        
        #create a sql file for uploading
        #date=Time.now().strftime("%Y%m%d")
        times=((Time.now().strftime("%H:%M:%S")).to_s).split(':')
	           		@con=Configuration.find(1)
	           			@folderpath=@con.FilesFolderPath
	           			if times[0].to_i>=@con.noofhours.to_i
	           			    date=Date.today.strftime("%Y%m%d")
	           			else
		           		    date=(Date.today-1).strftime("%Y%m%d")
		           		end

    
       
        fname="#{shopval[i]}_"+Date.parse(session[:dateval]).strftime("%Y%m%d")+".csv"
        total=0
        count=0
        @t= Clientdata.find(:all,:conditions=>["ShopName in (?) and status=0 and date=? ",shopval[i],session[:dateval]])
        FasterCSV.open(fname, "w") do |csv|
        for sname in @t
        @a=[sname.ClusterName,sname.ShopName,sname.Date,sname.GroupID,sname.MachineNo,sname.ScreenIN,sname.ScreenOUT,sname.MeterIN,sname.MeterOUT,sname.Machineshort,sname.Shortreason,sname.status,';']
        csv<< @a
        
    end
    
        end 

    #pw=Dir.pwd()
    #Dir.chdir(pw)
    #filename=pw.to_s+"/"+fname
    
    
    
    #fname="Counterdata_#{@cluster.ClusterName}_#{params[:clientdatas][:ShopName]}_"+date+".sql"
      total=0
      count=0
      @t= Countercollection.find(:all,:conditions=>["ShopName in (?) and status=0 and date=? ",shopval[i],session[:dateval]])
      
      FasterCSV.open(fname, "a") do |csv|
        csv<< "COUNTER"
        for cdata in @t
        #csv<< sname.ShopName+","+sname.GroupID+","+sname.MachineNo+","+sname.MachineName
        @a=[cdata.ClusterName,cdata.ShopName,cdata.Date,cdata.Cash,cdata.Exp,cdata.HC,cdata.Credit,cdata.Short_Ext,cdata.Openingbal,cdata.KEY1,cdata.KEY2,cdata.KEY3,cdata.KEY4,cdata.Outstanding,cdata.status,cdata.Total,';']
        csv<< @a
        
        end
        end 

    pw=Dir.pwd()
    Dir.chdir(pw)
    filename=pw.to_s+"/"+fname
    puts filename
    begin
     if File.directory?("#{@folderpath}")
         
    FileUtils.copy(filename, "#{@folderpath}")
    FileUtils.rm_r(filename)

    else
        FileUtils.mkdir_p "#{@folderpath}"
         FileUtils.copy(filename, "#{@folderpath}")
    end
    rescue Exception=>ex
    puts ex.message()
    end
    
=begin 
/*
    s=[]
    fp= File.open(filename, "r") 
        while(fp.eof!=true)
        s<<fp.readline
        
        end
     
     for i in 0..(s.length-1)
     a= s[i].to_s.split(',')
     puts a
     @e=Clientdata.new
     @e.ShopName=a[0]
     @e.save
     p "------------"
     end
*/
=end
     
        @statusflag= Clientdata.find(:all,:conditions=>["ShopName in (?) and status=0 and date=?",shopval[i],session[:dateval]])
                                @statusflag.each do |c| 
                            	c.status=1 
                            	c.save 
                            end
                            
        @counterstatusflag= Countercollection.find(:all,:conditions=>["ShopName in (?) and status=0 and date=?",shopval[i],session[:dateval]])
                                @counterstatusflag.each do |c| 
                            	c.status=1 
                            	c.save 
                            end
                            
   end                         
            
                  
 
    page.alert("FILE HAS BEEN CREATED SUCCESSFULLY")
   page.redirect_to url_for(:controller=>'clientdatas', :action=>'new')
    
    end              
    rescue Exception=>ex
    puts ex.message
    end
end


#METHOD WHILE CREATING A NEW clientdata
def createpreviousdata
    puts "in previosdata"
    puts params[:clientdata][:ScreenIN]
    
    if params[:clientdata][:ScreenIN]==""
        flash[:notice]="Screen IN can't be empty"
        render :action => 'previousdata'
    else
        if((params[:clientdata][:ShopName]==nil or params[:clientdata][:ShopName]=="") and @session[:shopname]!=nil)
            puts "in if"
            params[:clientdata][:ShopName]=@session[:shopname]
            puts params[:clientdata][:ShopName]
        end
        
        if((params[:clientdata][:GroupID]==nil or params[:clientdata][:GroupID]=="") and @session[:Groupid]!=nil)
            puts @session[:Groupid]
            params[:clientdata][:GroupID]=@session[:Groupid]
             
         end
         
         
         if((params[:clientdata][:MachineNo]==nil or params[:clientdata][:MachineNo]=="") and @session[:MachineNo]!=nil)
            params[:clientdata][:MachineNo]=@session[:MachineNo]
             
         end
         if((params[:clientdata][:MachineName]==nil or params[:clientdata][:MachineName]=="") and @session[:MachineName]!=nil)
            params[:clientdata][:MachineName]=@session[:MachineName]
             
         end
         puts "DATE"
         puts @session[:prevdate]
         puts params[:date]
         
         
          @date=Date.parse(params[:date])
        puts @date
       # @session[:prevdate]=@date

        if(@session[:prevdate]==nil)
             
        @date=Date.parse(params[:date])
        puts @date
        @session[:prevdate]=@date
         else           
        @date=@session[:prevdate]    
        end
       
        @duprecord=Machinedata.find_first(["Shop_Name=? and Group_ID=? and Machine_No=? and Machine_Name=?  and trans_date=?",params[:clientdata][:ShopName],params[:clientdata][:GroupID],params[:clientdata][:MachineNo],params[:clientdata][:MachineName],@date])
        
        
        if(@duprecord!=nil)
            flash[:notice]="<font color=red size=4><b>DUPLICATE PREVIOUS DATA ENTRY FOR MACHINE No. #{params[:clientdata][:MachineNo]}</b></font> "
            render :action => 'previousdata'
        else
            
            @cluster=Shop.find_first(["ShopName=?",params[:clientdata][:ShopName]])
            params[:clientdata][:ClusterName]=@cluster.ClusterName
            puts "jjjjjjjj"
            
  
            
            @data=Machinedata.new
            @data.CLUSTER_NAME=params[:clientdata][:ClusterName]
            @data.SHOP_NAME=params[:clientdata][:ShopName]
             @data.GROUP_ID=params[:clientdata][:GroupID]
             puts "DATE IS ************************"
             puts @date
             @data.TRANS_DATE=params[:date]
             #@data.T_DATE=@date.strftime("%d-%b-%Y")
              @data.MACHINE_NO=params[:clientdata][:MachineNo]
               @data.MACHINE_NAME=params[:clientdata][:MachineName]
              
                @data.SRIN=0
                 @data.SROUT=0
                  @data.MTRIN=0
                   @data.MTROUT=0
              
                @data.PSRINVALUE=params[:clientdata][:ScreenIN]
                 @data.PSROUTVALUE=params[:clientdata][:ScreenOUT]
                  @data.PMTRINVALUE=params[:clientdata][:MeterIN]
                   @data.PMTROUTVALUE=params[:clientdata][:MeterOUT]
                    @data.LASTSETTING="A"
                    @data.SETTING=params[:clientdata][:Setting]+" " +@date.strftime("%d/%m").to_s
                    
            
             if @data.save
                flash[:confirm] = '<font color=green size=4><b>PREVIOUS DATA ENTRY WAS SUCCESSFULLY CREATED.</b></font>'
                params[:clientdata][:ScreenIN]=""
                
                @session[:MachineNo]=nil
                @session[:MachineName]=nil
                render :action => 'previousdata'
            else
                render :action => 'previousdata'
            end
            
            
        end
    end
    
end


def checkupdate
    

end


def resetdata
   @s=Clientdata.find_first(["ShopName=? and GroupID=? and MachineNo=? and Date='#{@session['shortdate']}'",@session['shortshop'],@session['shortgroupid'],@session['shortmachineno']]) 
  @s.Machineshort=0
  @s.Shortreason=""
  @s.save
  render :update do |page|
   page.redirect_to url_for(:controller=>'clientdatas', :action=>'new')
    end
end

end
