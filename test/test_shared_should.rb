require 'helper'

class TestSharedShould < Test::Unit::TestCase
  # check that setup instance method is executed
  def setup
    super
    @setup_instance_method_executed = true
  end
  
  should "execute setup instance method" do
    assert @setup_instance_method_executed
  end
  
  context ".share_context" do
    context "without params" do
      share_context "for a valid value" do
        setup do
          @context_value = true
        end
      
        should "have true value" do
          assert @value
        end
      
        should "call setup in shared context" do
          assert @context_value
        end
      end
      
      context "with value in setup" do
        setup do
          @value = true
        end
  
        use_context "for a valid value"
      end
    
      context "with value in initializer" do
        use_context("for a valid value").when("a true value") { @value = true }
      end
    end
    
    context "with params" do
      setup do
        @value = true
      end
      
      share_context "for a valid specified value" do
        setup do |value|
          @expected_value = value
          @context_value = true
        end
        
        should "have specified value" do |value|
          assert_equal value, @value
        end
        
        should "setup @expected_value" do |value|
          assert_equal value, @expected_value
        end
        
        should "call setup in shared context" do
          assert @context_value
        end
      end
      
      use_context("for a valid specified value").when("true") { true }
    end
  end
  
  context ".shared_context_should" do
    context "without params" do
      setup do
        @value = true
      end
      
      shared_context_should "be valid" do
        setup do
          @context_value = true
        end
        
        should "have true value" do
          assert @value
        end
        
        should "call setup in shared context" do
          assert @context_value
        end
      end
      
      should_be_valid
    end
    
    context "with params" do
      setup do
        @value = true
      end
      
      shared_context_should "be valid for specified value" do
        setup do |value|
          @expected_value = value
          @context_value = true
        end
        
        should "have specified value" do |value|
          assert_equal value, @value
        end
        
        should "setup @expected_value" do |value|
          assert_equal value, @expected_value
        end
        
        should "call setup in shared context" do
          assert @context_value
        end
      end
      
      should_be_valid_for_specified_value { true }
    end
  end
  
  context ".share_should" do
    context "without params" do
      share_should "be a true value" do
        assert @value
      end
      
      context "with value in setup" do
        setup do
          @value = true
        end
        
        use_should "be a true value"
      end
      
      context "when value in initializer" do
        use_should("be a true value").when("value is true") { @value = true }
      end
      
      context "with value in initializer" do
        use_should("be a true value").with("true value") { @value = true }
      end
    end
    
    context "with params" do
      setup do
        @value = true
      end
      
      share_should "be a valid specified value" do |value|
        assert_equal value, @value
      end
      
      use_should("be a valid specified value").when("true") { true }
    end
  end
  
  context ".shared_should" do
    context "without params" do
      setup do
        @value = true
      end
      
      shared_should "have true value" do
        assert @value
      end
      
      should_have_true_value
    end
    
    context "with params" do
      setup do
        @value = true
      end
      
      shared_should "have specified value" do |value|
        assert_equal value, @value
      end
      
      should_have_specified_value { true }
    end
  end
  
  context ".shared_setup" do
    context "without params" do
      shared_setup "for value" do
        @value = true
      end
  
      context "with shared setup value" do
        setup do
          @value = false
        end
  
        setup_for_value
  
        should "have a true value from shared setup" do
          assert @value
        end
      end
    end
    
    context "with params" do
      shared_setup "for value" do |value|
        @value = value
      end
      
      context "with shared setup value" do
        setup do
          @value = false
        end
      
        setup_for_value("with true") { true }
      
        should "have a true value from shared setup" do
          assert @value
        end
      end
    end
  end
  
  context ".share_setup" do
    context "without params" do
      context "without initialization block" do
        setup do
          # value that will be overwritten
          @value = false
        end
  
        share_setup "for true value" do
          @value = true
        end
  
        use_setup("for true value")
  
        should "have a true value from shared setup" do
          assert @value
        end
      end
      
      context "with initialization block" do
        setup do
          # value that will be overwritten
          @value = false
        end
  
        share_setup "for value" do
          @value = @initialization_value
        end
  
        use_setup("for value").with("true initialization value") { @initialization_value = true }
  
        should "have a true value from shared setup" do
          assert @value
        end
      end
    end
    
    context "with parameterized initialization block" do
      share_setup "for value" do |value|
        @value = value
      end
      
      context "with shared setup value" do
        setup do
          # value that will be overwritten
          @value = false
        end
      
        use_setup("for value").with("true initialization value") { true }
      
        should "have a true value from shared setup" do
          assert @value
        end
      end
    end
  end
  
  context "parameterized block" do
    shared_context_should "be valid with shared context" do
      setup do
        assert [1, 2, 3], shared_value
      end
      
      setup do |value|
        assert [1, 2, 3], value
      end
      
      setup do |first, second, third|
        assert 1, first
        assert 2, second
        assert 3, third
      end
      
      should "do something with shared_value" do
        assert [1, 2, 3], shared_value
      end
      
      should "do something with value block param" do |value|
        assert [1, 2, 3], value
      end
      
      should "do something with value block params" do |first, second, third|
        assert 1, first
        assert 2, second
        assert 3, third
      end
    end
    
    shared_should "be valid with shared should" do |first, second, third|
      assert 1, first
      assert 2, second
      assert 3, third
    end
    
    should_be_valid_with_shared_context("with an array") { ['1', '2', '3'] }
    
    should_be_valid_with_shared_should("with an array") { ['1', '2', '3'] }
  end
  
  context "context directly under test class" do
    share_setup "for a true value" do
      @value = true
    end
    
    share_should "be a valid should test" do
      assert @value
    end
    
    share_context "for a valid context test" do
      should "have a true value" do
        assert @value
      end
    end
  
    use_setup "for a true value"
    
    use_should "be a valid should test"
    
    use_context "for a valid context test"
  end
  
  # test class as context
  share_setup "for a true value in class" do
    @class_value = true
  end
  
  share_should "be a valid should test in class" do
    assert @class_value
  end
  
  share_context "for a valid context test in class" do
    should "have a true value" do
      assert @class_value
    end
  end
  
  use_setup "for a true value in class"
  
  use_should "be a valid should test in class"
  
  use_context "for a valid context test in class"
  
  
  # ensure should macros work
  def self.should_be_a_valid_macro
    should "be a valid macro" do
      assert true
    end
  end
  
  context "shoulda macro" do
    should_be_a_valid_macro
  end
  
  # ensure NoMethodError called when method not found
  begin
    invalid_method do
    end
    raise "Should have raised a NoMethodError"
  rescue NoMethodError
    # successfully raised NoMethodError
  end
  
  context "NoMethodError check" do
    begin
      invalid_method do
      end
      raise "Should have raised a NoMethodError"
    rescue NoMethodError
      # successfully raised NoMethodError
    end
  end
  
  # ensure test methods are created
  expected_method_names = [
    "test: .share_context with params when true for a valid specified value should call setup in shared context. ",
    "test: .share_context with params when true for a valid specified value should call setup in shared context. ",
    "test: .share_context with params when true for a valid specified value should have specified value. ",
    "test: .share_context with params when true for a valid specified value should setup @expected_value. ",
    "test: .share_context without params with value in initializer when a true value for a valid value should call setup in shared context. ",
    "test: .share_context without params with value in initializer when a true value for a valid value should have true value. ",
    "test: .share_context without params with value in setup for a valid value should call setup in shared context. ",
    "test: .share_context without params with value in setup for a valid value should have true value. ",
    "test: .shared_context_should with params be valid for specified value should call setup in shared context. ",
    "test: .shared_context_should with params be valid for specified value should have specified value. ",
    "test: .shared_context_should with params be valid for specified value should setup @expected_value. ",
    "test: .shared_context_should without params be valid should call setup in shared context. ",
    "test: .shared_context_should without params be valid should have true value. ",
    "test: .shared_setup with params with shared setup value should have a true value from shared setup. ",
    "test: .shared_setup without params with shared setup value should have a true value from shared setup. ",
    "test: .share_setup with parameterized initialization block with shared setup value should have a true value from shared setup. ",
    "test: .share_setup without params with initialization block should have a true value from shared setup. ",
    "test: .share_setup without params without initialization block should have a true value from shared setup. ",
    "test: .shared_should with params should have specified value. ",
    "test: .shared_should without params should have true value. ",
    "test: .share_should with params when true should be a valid specified value. ",
    "test: .share_should without params when value in initializer when value is true should be a true value. ",
    "test: .share_should without params with value in initializer with true value should be a true value. ",
    "test: .share_should without params with value in setup should be a true value. ",
    "test: context directly under test class for a valid context test should have a true value. ",
    "test: context directly under test class should be a valid should test. ",
    "test: parameterized block with an array be valid with shared context should do something with shared_value. ",
    "test: parameterized block with an array be valid with shared context should do something with value block param. ",
    "test: parameterized block with an array be valid with shared context should do something with value block params. ",
    "test: parameterized block with an array should be valid with shared should. ",
    "test:  should be a valid should test in class. ",
    "test: for a valid context test in class should have a true value. ",
    "test: SharedShould should execute setup instance method. ",
    "test: shoulda macro should be a valid macro. "
  ].inject({}) do |hash, expected_method_name|
    hash[expected_method_name] = true
    hash
  end
  actual_method_names = suite.tests.inject({}) do |hash, test_case|
    hash[test_case.method_name] = true
    hash
  end
  
  expected_method_names.each do |method_name, value|
    raise "Test method not found: '#{method_name}'" unless actual_method_names.include?(method_name)
  end
  actual_method_names.each do |method_name, value|
    raise "Unexpected test method: '#{method_name}'" unless expected_method_names.include?(method_name)
  end
end
