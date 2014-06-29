require 'spec_helper'

describe SexyScopes::Arel::Nodes::RegexpMatches do
  before do
    @attribute = User.attribute(:username)
  end

  context "case sensitive" do
    subject { @attribute =~ /bob|alice/ }

    db :postgresql do
      it { should convert_to_sql %{"users"."username" ~ 'bob|alice'} }
    end

    db :mysql do
      it { should convert_to_sql %{`users`.`username` REGEXP BINARY 'bob|alice'} }
    end

    db :sqlite3 do
      it { should convert_to_sql %{"users"."username" REGEXP 'bob|alice'} }
    end
  end

  context "case insensitive" do
    subject { @attribute =~ /bob|alice/i }

    db :postgresql do
      it { should convert_to_sql %{"users"."username" ~* 'bob|alice'} }
    end

    db :mysql do
      it { should convert_to_sql %{`users`.`username` REGEXP 'bob|alice'} }
    end

    db :sqlite3 do
      it { should convert_to_sql %{"users"."username" REGEXP 'bob|alice'} }
    end
  end
end
