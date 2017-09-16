require 'spec_helper'

describe SexyScopes::ActiveRecord::QueryMethods do
  describe ".where(&block)" do
    context "sent to an ActiveRecord::Base class" do
      subject { User }

      it "should execute the block in the context of the class" do
        expect_block_to_be_executed_in_context_or_with_argument User.all
      end

      it "should use the returned expression as conditions" do
        relation = subject.where { score == 5 }
        expect(relation).to convert_to_sql %{SELECT "users".* FROM "users" WHERE "users"."score" = 5}
      end
    end

    context "sent to an ActiveRecord::Relation" do
      subject { User.select('1') }

      it "should execute the block in the context of the relation" do
        expect_block_to_be_executed_in_context_or_with_argument
      end

      it "should use the returned expression as conditions" do
        relation = subject.where { score == 5 }
        expect(relation).to convert_to_sql %{SELECT 1 FROM "users" WHERE "users"."score" = 5}
      end
    end

    context "sent to an association proxy" do
      before do
        @bob = User.create(username: 'bob')
      end

      subject {
        @bob.messages
      }

      it "should execute the block in the context of the association" do
        expect_block_to_be_executed_in_context_or_with_argument
      end

      it "should use the returned expression as conditions" do
        relation = subject.where { body =~ '%alice%' }
        if SexyScopes.arel_9?
          expect(relation).to convert_to_sql <<-SQL.strip
            SELECT "messages".* FROM "messages" WHERE "messages"."author_id" = #{@bob.id} AND "messages"."body" LIKE '%alice%'
          SQL
        else
          expect(relation).to convert_to_sql <<-SQL.strip
            SELECT "messages".* FROM "messages" WHERE "messages"."author_id" = #{@bob.id} AND ("messages"."body" LIKE '%alice%')
          SQL
        end
      end
    end

    context "called with both arguments and a block" do
      it "should raise an ArgumentError" do
        expect {
          User.where(username: 'bob') { score == 5 }
        }.to raise_error ArgumentError, "You can't use both arguments and a block"
      end
    end

    def expect_block_to_be_executed_in_context_or_with_argument(expected_context = subject)
      context = nil
      expect {
        subject.where {
          context = self
          throw :block_called
        }
      }.to throw_symbol :block_called
      expect(context).to eq expected_context

      context = nil
      expect {
        subject.where { |rel|
          context = rel
          throw :block_called
        }
      }.to throw_symbol :block_called
      expect(context).to eq expected_context
    end
  end
end
