class ReportsController < ApplicationController

layout 'adminlayout'
require 'date'
before_filter :login_required
 
=begin
   def expencereport
    
  puts "in expence report"
  @session[:month]=params[:date][:month]
  @session[:year]=params[:date][:year]
  @session[:shop]=params[:group][:ShopName]
  @session[:days]=(Date.new(@session[:year].to_i, 12, 31) << (12-@session[:month].to_i)).day
  @session[:startdate]=Date.parse(01.to_s+'-'+@session[:month].to_s+'-'+@session[:year].to_s)
  @session[:enddate]=Date.parse(@session[:days].to_s+'-'+@session[:month].to_s+'-'+@session[:year].to_s)
  puts @session[:startdate]
  puts @session[:enddate]
  puts @session[:days]
  puts "------------------------"
  puts @session[:month]
  puts @session[:year]
  puts @session[:clustername]
  puts @session[:shop]
  puts "------------------------"
  redirect_to :action => 'exreportlist'
  
  end
  
  #METHOD FOR GETTING SHOPNAME ON SELECTING GROUP
 def getShopName
   begin
   puts "gggggggggggggggggggggggggggg"
    puts params[:ClusterName]
    
    puts "at getShopeName Method......"
    @shop=Shop.find_first(["ClusterName=?",params[:ClusterName]])
    
    @session[:clustername]=params[:ClusterName]
    
    render :update do |page|
        page.replace_html 'shopnamediv', :partial => 'shopexpname'
    end
    
    rescue Exception=>exc
        puts exc.message
      end
      end
  def search
    begin
     p "in search"
    @session['groupcluster']=nil 
    @session['groupshop']=nil
    @session['groupkey']=nil 
        p params[:machine][:ClusterName]
        p params[:machine][:ShopName]
        p params[:machine][:GroupID]
        if(params[:machine][:ClusterName]=="")
        @session['groupcluster']=@session[:clustername]
        else
        @session['groupcluster']=params[:machine][:ClusterName]
        end
    
        if(params[:machine][:ShopName]=="")
        @session['groupshop']=@session[:shopname]
        else
        @session['groupshop']=params[:machine][:ShopName]
        end
    
        if(params[:machine][:GroupID]=="")
        @session['groupkey']=@session[:Groupid]
        else
        @session['groupkey']=params[:machine][:GroupID]
        end
    
    
   
    
        redirect_to :action=>'list'
    rescue Exception=>ex
    end
  end
  
  #REFRESHING PARTIAL FOR GETTING SHOPS UNDER SELECTED GROUP
def getShop
    begin
    puts "IN getSHOP"
   puts params[:ClusterName]
    session[:shopname]=nil
    @session[:clustername]=params[:ClusterName]
    render :update do |page|
	  page.replace_html 'ShopNamediv', :partial => 'shopname'
  end
  rescue Exception=>ex
  puts ex.message()
  end
end
 
 
 #REFRESHING PARTIAL FOR GETTING KEYS UNDER SELECTED SHOP
 def getGroup
     puts "getGroup"
     puts params[:ShopName]
     session[:shopname]=params[:ShopName]
     render :update do |page|
	  page.replace_html 'KeyIDdiv', :partial => 'groupID'
    end
end

 

  
  def list
    @machine_pages, @machines = paginate :machines, :per_page => 10
  end
=end


def search
    begin
    p "in search"
    puts @session[:rrclustername]
    puts @session[:rrshopname]
    puts @session[:rrgroupid]  
    @session[:rrclustername]=params[:machinedata][:ClusterName]
    redirect_to :action=>'list'
    rescue Exception=>ex
    end
end



def expencereport
begin
  #puts "in expence report"
  #puts Time.now()
  @session[:month]=params[:date][:month]
  @session[:year]=params[:date][:year]
 
  @session[:days]=(Date.new(@session[:year].to_i, 12, 31) << (12-@session[:month].to_i)).day
  @session[:startdate]=Date.parse(01.to_s+'-'+@session[:month].to_s+'-'+@session[:year].to_s)
  @session[:enddate]=Date.parse(@session[:days].to_s+'-'+@session[:month].to_s+'-'+@session[:year].to_s)
  @session[:rrclustername]=params[:machinedata][:ClusterName]
  
  #puts @session[:startdate]
  #puts @session[:enddate]
  #puts @session[:days]
  #puts "------------------------"
  #puts @session[:month]
  #puts @session[:year]
  #puts @session[:rrclustername]
  #puts @session[:rrshopname]
  #puts "------------------------"
  #render :action=>'exreport'
  redirect_to :action => 'exreportlist'
  rescue Exception=>ex
  puts ex.message
  end
  end


def setGroup
    begin
    if(params[:ClusterName]!="" or params[:ClusterName]!=nil)
        @session[:rrclustername]=params[:ClusterName]
    end
   
    
    
    
        @session[:rrshopname]=nil
        render :update do |page|
	    page.replace_html 'Shopdiv', :partial => 'shop'
        page << "document.getElementById('machinedata_ShopName').focus();"
        end
    rescue Exception=>exc
        puts exc.message
    end
end



def setGroupdaily 
puts "in setgroupdaily"
begin
    if(params[:ClusterName]!="" or params[:ClusterName]!=nil)
        @session[:rrclustername]=params[:ClusterName]
         @session[:rrclusternamedaily]=params[:ClusterName]
    end
   @clustarray=[]
    puts @session[:rrclusternamedaily]
    if(@session[:rrclusternamedaily]=="ALL")
        @group=Cluster.find(:all, :order => "ClusterName")
        
        for item in @group
            @clustarray<< item.ClusterName
        end
        len=@clustarray.length 
        @dev=[] 

        for i in 0..len-1 do
        if i==len-1
        @dev<<'\''+@clustarray[i].to_s+'\''
        else 
        @dev<<'\''+@clustarray[i].to_s+'\'' 
        @dev<<',' 
        end 
    end 
        @session[:clustarray]=@clustarray
        @session[:rrclusternamedaily]=@dev
        puts "CLUSTER"
        puts @session[:clusterarray]
        
        @session[:rrshopname]=nil
        render :update do |page|
	    page.replace_html 'Shopdiv', :partial => 'shopdaily'
       page << "document.getElementById('machinedata_ShopName').options[0].selected=true;"
        #page << "document.getElementById('machinedata_ShopName').options[0].focus();"
        end
    else
         
        @clust=[]
        @clust<<'\''+@session[:rrclusternamedaily]+'\''
        
        @session[:clustarray]=@session[:rrclusternamedaily]
        @clust=[]
        @clust<<'\''+@session[:rrclusternamedaily].to_s+'\''
        @session[:rrclusternamedaily]=nil
        @session[:rrclusternamedaily]=@clust
        puts "%%%%%%%%%%%%%%%%%%%%%%%%%"
        puts @session[:rrclustername]
        @session[:rrshopname]=nil
        render :update do |page|
	    page.replace_html 'Shopdiv', :partial => 'shopdaily'
        page << "document.getElementById('machinedata_ShopName').options[0].selected=true;"
        page << "document.getElementById('machinedata_ShopName').focus();"
    end
    end
    rescue Exception=>exc
        puts exc.message
    end
end


def setShopdaily
    puts "in setShopdaily"
   
    begin
    if(params[:ShopName]!="" or params[:ShopName]!=nil)
        @session[:rrshopname]=params[:ShopName]
    end
    puts @session[:rrshopname]
    rescue Exception=>ex
    end
end 

def setShop
    puts "in setShop"
    begin
    if(params[:ShopName]!="" or params[:ShopName]!=nil)
        @session[:rrshopname]=params[:ShopName]
    end
       puts @session[:rrshopname]
        render :update do |page|
	   
       
        page.replace_html 'Machinediv', :partial => 'machine'
        #page << "document.getElementById('machinedata_GroupID').focus();"
      
        end
    rescue Exception=>exc
        puts exc.message
    end
end

def setMName
  @session[:rrmname]=params[:MachineName]
  #puts @session[:rrmname]
end

def setMcGroup
    begin
    if(params[:ClusterName]!="" or params[:ClusterName]!=nil)
        @session[:rrclustername]=params[:ClusterName]
    end
        @session[:rrshopname]=nil
        render :update do |page|
	    page.replace_html 'Shopdiv', :partial => 'shopmcsummary'
        page << "document.getElementById('machinedata_ShopName').focus();"
        end
    rescue Exception=>exc
        puts exc.message
    end
end
def setMcShop
  
    begin
    if(params[:ShopName]!="" or params[:ShopName]!=nil)
        @session[:rrshopname]=params[:ShopName]
    end
        puts @session[:rrshopname]
        render :update do |page|
          
        page.replace_html 'KeyIDdiv', :partial => 'group'
        page << "document.getElementById('machinedata_GroupID').focus();"
        end
    rescue Exception=>exc
        puts exc.message
    end
end

def setKey
    puts "in setKey"
    begin
    
    @session[:rrgroupid]=nil
    if(params[:GroupID]!="" )
    @session[:rrgroupid]=params[:GroupID]
    end
    
    render :update do |page|
	  #page.replace_html 'KeyIDdiv', :partial => 'group'
      #page.replace_html 'MachineNodiv', :partial => 'machine'
       page << "document.getElementById('save').select();"
      page << "document.getElementById('save').focus();"
   end
rescue Exception=>exc
     puts exc.message
end
end

def showdailyreport
  puts "In daily report"
  puts params[:key]#[keywise]
  puts @session[:rrclusternamedaily]
  puts @session[:clustarray]
  puts params[:machinedata][:ClusterName]
  #CLUSTER
  @clustarray=[]
  if(@session[:clusterarray]!=params[:machinedata][:ClusterName])
        if(params[:machinedata][:ClusterName]=="ALL")
        @group=Cluster.find(:all)
        
        for item in @group
            @clustarray<< item.ClusterName
        end
        len=@clustarray.length 
        @dev=[] 

        for i in 0..len-1 do
        if i==len-1
        @dev<<'\''+@clustarray[i].to_s+'\''
        else 
        @dev<<'\''+@clustarray[i].to_s+'\'' 
        @dev<<',' 
        end 
        end 
        @session[:clustarray]=@clustarray
        @session[:rrclusternamedaily]=@dev
        end
  end
  
  #CLUSTER END
  
  
  
  
  
  puts params[:date]
  @date=params[:date]
  @day=@date.split('-');
  puts @day[0]
  puts @day[1]
  puts @day[2]
  
  @session[:startdatehc]=Date.parse(01.to_s+'-'+@day[1].to_s+'-'+@day[0].to_s)
  @session[:enddatehc]=Date.parse(@day[2].to_s+'-'+@day[1].to_s+'-'+@day[0].to_s)
  @session[:datediff]=@session[:enddatehc]-@session[:startdatehc]
  puts "date diff= #{@session[:datediff]}"
  puts @session[:enddatehc]
  
   @session[:shoparray1]=params[:machinedata][:ShopName]
    puts @session[:shoparray1]

    puts "#############shop array begin#########################"
    if(@session[:shoparray1].to_s!='ALL')
    len=@session[:shoparray1].length 
    puts len
    @shop=[]

    for i in 0..len-1 do 
    if i==len-1 
    @shop<<'\''+@session[:shoparray1][i].to_s+'\'' 
    else 
    @shop<<'\''+@session[:shoparray1][i].to_s+'\'' 
    @shop<<',' 
    end 

 end 
    @session[:shoparray]=@shop.to_s 
    else
        puts "in else"
        ##############pending for all shops selected
        @carray=@session[:clustarray].to_s
        puts @carry
    end
 
   puts "#######################shop array end#########################"
  if params[:date]!=nil
      puts "hdgtsadhsgdhsgdhgsd"
  session[:dailyvalue]=params[:date]
  puts @session[:clustarray]
  puts @session[:rrclusternamedaily].to_s
  puts @session[:shoparray].to_s
  puts session[:dailyvalue]
  
  
  #@machinesdata=Machinedata.find(:all,:conditions=>["CLUSTER_NAME in (?) and SHOP_NAME in (?) and TRANS_DATE=?",@session[:clustarray],@session[:shoparray].to_s,session[:dailyvalue]],:order => "MACHINE_NO") 
  #@machinesdata=Machinedata.count("select * from Machinedatas where CLUSTER_NAME in ('#{@session[:clustarray]}') and SHOP_NAME in (#{@session[:shoparray].to_s}) ") 
  @machinesdata1=Machinedata.count(:conditions=>["CLUSTER_NAME in (#{@session[:rrclusternamedaily].to_s}) and SHOP_NAME in (#{@session[:shoparray].to_s}) and TRANS_DATE>='#{@session[:startdatehc]}' and TRANS_DATE<='#{@session[:enddatehc]}'"]) 
   #@machinesdata1=Machinedata.count(:conditions=>["CLUSTER_NAME in ('LAT','A') and SHOP_NAME in ('20NEWSHOP') "]) 
 puts @machinesdata1
 @count=0
=begin  
  elsif (params[:key]=="ALLKEYS")
           redirect_to :action=>'displaydailyreportallkey'
      elsif (params[:key]=="NAMEWISE")
            redirect_to :action=>'displaydailyreportnamewise'
      else
            redirect_to :action=>'displaydailyreportnowise'
       end    
=end
  puts "sjdhdjhdjhsdjhd"
  if(@machinesdata1.to_i>0)
      if(params[:key]=="KEYWISE" and params[:machine]=="NAMEWISE") 
        redirect_to :action=>'displaydailyreport'
      end
      if(params[:key]=="ALLKEYS" and params[:machine]=="NAMEWISE") 
        redirect_to :action=>'displaydailyreportallkey'
      end
      if(params[:key]=="ALLKEYS" and params[:machine]=="NOWISE") 
        redirect_to :action=>'displaydailyreportnoall'
      end
      if(params[:key]=="KEYWISE" and params[:machine]=="NOWISE") 
        redirect_to :action=>'displaydailyreportnokey'
      end
      
  else
      flash[:notice]="NO RECORD FOUND"
  render :action=>'dailyreport'
  end
  end
end


def displaydailyreport
end


def showmachinesummaryreport
    puts "In machine Summary----------------"
    puts params[:date1]
  if params[:date1]!=nil and params[:date2]!=nil
  session[:ttdate1]=params[:date1]
  session[:ttdate2]=params[:date2]
  redirect_to :action=>'showmachinesummaryreport'
  end  
end


def showshortreasonsreport
    puts "SHORT REASON"
 puts params[:data]
  
  puts @session[:rrclustername]
   puts @session[:rrshopname]
  
  @session[:rrclustername]=params[:machinedata][:ClusterName]
  @session[:month]=params[:date][:month]
  @session[:year]=params[:date][:year]
   puts @session[:month]
  puts @session[:year]
 
  @session[:days]=(Date.new(@session[:year].to_i, 12, 31) << (12-@session[:month].to_i)).day
 
  @session[:startdate]=Date.parse(01.to_s+'-'+@session[:month].to_s+'-'+@session[:year].to_s)
  @session[:enddate]=Date.parse(@session[:days].to_s+'-'+@session[:month].to_s+'-'+@session[:year].to_s)
  puts @session[:days]
  puts @session[:startdate]
  puts @session[:enddate]
 
  
end

def hcreport
  begin
  puts "in hc report"
  @session[:monthhc]=params[:date][:month]
  @session[:yearhc]=params[:date][:year]
  
  @session[:dayshc]=(Date.new(@session[:yearhc].to_i, 12, 31) << (12-@session[:monthhc].to_i)).day
  
  @session[:startdatehc]=Date.parse(01.to_s+'-'+@session[:monthhc].to_s+'-'+@session[:yearhc].to_s)
  @session[:enddatehc]=Date.parse(@session[:dayshc].to_s+'-'+@session[:monthhc].to_s+'-'+@session[:yearhc].to_s)
  @session[:rrclustername]=params[:machinedata][:ClusterName]
  
   puts @session[:startdatehc]
  puts @session[:enddatehc]
  puts @session[:dayshc]

  redirect_to :action => 'hcreportlist'
  rescue
  end
end

def showcounterwise
  puts "in counter wise report"
  @session[:monthhc]=params[:date][:month]
  @session[:yearhc]=params[:date][:year]
  
  @session[:dayshc]=(Date.new(@session[:yearhc].to_i, 12, 31) << (12-@session[:monthhc].to_i)).day
  
  @session[:startdatehc]=Date.parse(01.to_s+'-'+@session[:monthhc].to_s+'-'+@session[:yearhc].to_s)
  @session[:enddatehc]=Date.parse(@session[:dayshc].to_s+'-'+@session[:monthhc].to_s+'-'+@session[:yearhc].to_s)
  
   puts @session[:startdatehc]
  puts @session[:enddatehc]
  puts @session[:dayshc]
  @session[:rrclustername]=params[:machinedata][:ClusterName]
  ##redirect_to :action => 'hcreportlist'
  
end

def shownamewisesummary
  session[:ttdate1]=params[:date1]
  session[:ttdate2]=params[:date2]
  redirect_to :action=>'showmachinesummaryreportnamewise'
end
def shortextra
  begin
  puts "in Short Extra........"
  @session[:month]=params[:date][:month]
  @session[:year]=params[:date][:year]
  
  @session[:days]=(Date.new(@session[:yearhc].to_i, 12, 31) << (12-@session[:monthhc].to_i)).day
  
  @session[:startdate]=Date.parse(01.to_s+'-'+@session[:monthhc].to_s+'-'+@session[:yearhc].to_s)
  @session[:enddate]=Date.parse(@session[:dayshc].to_s+'-'+@session[:monthhc].to_s+'-'+@session[:yearhc].to_s)
  @session[:rrclustername]=params[:machinedata][:ClusterName]
  #if(params[:ShopName]!="" or params[:ShopName]!=nil)
        @session[:rrshopname]=params[:machinedata][:ShopName]
    #end
  
   puts @session[:startdate]
  puts @session[:enddate]
  puts @session[:days]
  puts @session[:rrclustername]
  puts @session[:rrshopname]

  redirect_to :action => 'showshortextra'
  rescue
  end
end

def getShopForSE
   begin
    if(params[:ClusterName]!="" or params[:ClusterName]!=nil)
        @session[:rrclustername]=params[:ClusterName]
    end
   
    
    
    
        @session[:rrshopname]=nil
        render :update do |page|
	    page.replace_html 'Shopdiv', :partial => 'shopse'
        
        end
    rescue Exception=>exc
        puts exc.message
    end
end

def setShopSE
    
    begin
    if(params[:ShopName]!="" or params[:ShopName]!=nil)
        @session[:rrshopname]=params[:ShopName]
    end
       #puts @session[:rrshopname]
        #render :update do |page|
	   
       
        #page.replace_html 'Machinediv', :partial => 'machine'
        #page << "document.getElementById('machinedata_GroupID').focus();"
      
        #end
    rescue Exception=>exc
        puts exc.message
    end
end

end
