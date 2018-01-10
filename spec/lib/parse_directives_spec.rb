# frozen_string_literal: true

describe CSPUtil do
  describe '#parse_directives' do
    let(:serialized_policy) do
      <<-POLICY
        default-src  'self'  ;  script-src 'self'; connect-src ;
       object-src 'self';base-uri 'none';
       report-uri https://logs.templarbit.com/csp/foobar/reports;
      POLICY
    end
    let(:expected_directives) do
      [
        {
          name:  'default-src',
          value: ["'self'"]
        },
        {
          name:  'script-src',
          value: ["'self'"]
        },
        {
          name:  'connect-src',
          value: []
        },
        {
          name:  'object-src',
          value: ["'self'"]
        },
        {
          name:  'base-uri',
          value: ["'none'"]
        },
        {
          name:  'report-uri',
          value: ['https://logs.templarbit.com/csp/foobar/reports']
        }
      ]
    end
    let(:directives) { CSPUtil.parse_directives(serialized_policy) }

    it 'parses directives correctly' do
      expect(directives.map(&:to_h)).to eq(expected_directives)
    end

    context 'when there are duplicated directives' do
      let(:serialized_policy) { "object-src 'self'; object-src 'none'" }

      it 'throws DuplicateDirective error' do
        expect { directives }.to raise_error(CSPUtil::DuplicateDirective)
      end
    end

    context 'when there is unknown directive' do
      let(:serialized_policy) { "bogus 'self'" }

      it 'throws DirectiveNameUnknown error' do
        expect { directives }.to raise_error(CSPUtil::DirectiveNameUnknown)
      end
    end
  end
end
