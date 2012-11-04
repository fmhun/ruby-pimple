describe 'Getter And Setter' do
  
  describe "setter" do
  
    before(:each) do
      @container= Pimple.new
    end

    it "should get a service defined with block  " do
      @container.set(:db_host) {|c| "127.0.0.1" }
      @container.set(:db) {|c| "mysql://#{c[:db_host]}" }

      @container[:db_host].should == "127.0.0.1"
      @container[:db].should == "mysql://127.0.0.1"
    end

    it "should get a service defined without block" do
      @container.set(:db_host,value:"127.0.0.1")
      @container[:db_host].should == "127.0.0.1"
    end

    it "should get a service using method_missing getter and block" do
      @container.db_host {|c| "127.0.0.1" }
      @container.db {|c| "mysql://#{c[:db_host]}" }

      @container[:db_host].should == "127.0.0.1"
      @container[:db].should == "mysql://127.0.0.1"
    end

    it "should get a service using method_missing getter with no block" do
      @container.db_host "127.0.0.1"
      @container.db "mysql://#{@container[:db_host]}"

      @container[:db_host].should == "127.0.0.1"
      @container[:db].should == "mysql://127.0.0.1"
    end
  end

  describe "getter" do
    
    before(:each) do
      @container= Pimple.new
      @container.db_host "127.0.0.1"
      @container.db "mysql://#{@container[:db_host]}"
    end
    
    it "should get a service with get" do 
      @container.get(:db).should == "mysql://127.0.0.1"
    end

    it "should get a service with method_missing" do 
      @container.db.should == "mysql://127.0.0.1"
    end
  end
end
