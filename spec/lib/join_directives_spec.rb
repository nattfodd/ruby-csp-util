# frozen_string_literal: true

describe CSPUtil do
  describe '#join_directives' do
    let(:serialized_policy) do
      <<-POLICY
        default-src 'self'; script-src 'self'; connect-src;
        object-src 'self'; base-uri 'none';
        report-uri https://logs.templarbit.com/csp/foobar/reports;
      POLICY
    end
    let(:directives) { CSPUtil.parse_directives(serialized_policy) }

    it 'returns policy string formed from directives' do
      expect(CSPUtil.join_directives(directives))
        .to eq("default-src 'self'; script-src 'self'; connect-src; "\
          "object-src 'self'; base-uri 'none'; "\
          'report-uri https://logs.templarbit.com/csp/foobar/reports')
    end
  end
end
