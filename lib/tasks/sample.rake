namespace :game do
  desc 'example ---'
	task :short_extra => :environment do
    #Advert.active.each {|advert| advert.expire_advert}
    p "========================>"
    @clustername='MRL'
    @sname='BANK'
    @trdate='2011-06-08'

    Group.find(:all,:select=>'GroupID',:conditions=>["ClusterName=? and ShopName=?",@clustername,@sname]).each do |key|
      p key.GroupID
      machine_data = Machinedata.find(:all,
                                      :conditions=> ["Cluster_Name=? and Shop_Name=? and TRANS_DATE=? and GROUP_ID=?",
                                      @clustername,@sname,@trdate,key.GroupID])

      @tot_short_extra=0
      machine_data.each do |data|
        if data.CALCULATEBY.eql?('S')
          short_extra = (((((data.TSRIN.to_f*data.SCREEN_RATE_IN.to_f)-(data.TSROUT.to_f*data.SCREEN_RATE_OUT.to_f))/10)*data.MULTIPLY_BY)+data.MTRSHORT.to_f).round
          @tot_short_extra = @tot_short_extra + short_extra
          #ShortExtra.find_or_create_by_date_and_cluster_name_and_shop_name_and_group_id_and_short_extra("#{@trdate}","#{@clustername}","#{@sname}","#{@gid}",short_extra)
          p "----------by-S-#{@tot_short_extra}-----------"
        else
          short_extra =(((((data.TMTRIN.to_f*data.MTR_RATE_IN.to_f)-(data.TMTROUT.to_f*data.MTE_RATE_OUT.to_f))/10)*data.MULTIPLY_BY)+data.MTRSHORT.to_f).round
          @tot_short_extra = @tot_short_extra + short_extra
          p "----------by-M-#{@tot_short_extra}-----------"
          #ShortExtra.find_or_create_by_date_and_cluster_name_and_shop_name_and_group_id_and_short_extra("#{@trdate}","#{@clustername}","#{@sname}","#{@gid}",short_extra)
        end
      end

       keys = Counterdata.find(:first,:conditions=>["ClusterName=? and ShopName=? and DATE=?",
                                                            @clustername,@sname,@trdate])
                 if keys!= nil
											 if key.GroupID.eql?('KEY 1')
												 keyval=keys.KEY1.to_i
											end
											 if key.GroupID=='KEY 2'
												 keyval=keys.KEY2.to_i
											end
											if key.GroupID=='KEY 3'
												 keyval=@keys.KEY3.to_i
											 end
                       if key.GroupID=='KEY 4'
												 keyval=@keys.KEY4.to_i
											 end
                 end
            short_extra = (keyval.to_i - @tot_short_extra.to_i)
    ShortExtra.find_or_create_by_date_and_cluster_name_and_shop_name_and_group_id_and_short_extra("#{@trdate}","#{@clustername}","#{@sname}","#{key.GroupID}",short_extra)
    end
	end
end