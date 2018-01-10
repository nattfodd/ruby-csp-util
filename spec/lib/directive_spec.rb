# frozen_string_literal: true

describe CSPUtil::Directive do
  let(:directive) { described_class.new(token) }

  context 'for fully specified token' do
    let(:token) { "default-src  'self'" }

    it 'creates new valid directive' do
      expect(directive.name).to eq('default-src')
      expect(directive.value).to eq(["'self'"])
    end

    describe '#to_h' do
      it 'returns hash with name & value' do
        expect(directive.to_h).to eq(name: 'default-src', value: ["'self'"])
      end
    end

    describe '#to_s' do
      it 'returns policy entry' do
        expect(directive.to_s).to eq("default-src 'self'")
      end
    end
  end

  context 'when token contains only directive name' do
    let(:token) { 'connect-src' }

    it 'creates new valid directive with empty value' do
      expect(directive.name).to eq('connect-src')
      expect(directive.value).to eq([])
    end
  end

  context 'when token contains directive name and URI' do
    let(:token) { 'report-uri https://logs.templarbit.com/csp/foobar/reports' }

    it 'creates new valid directive' do
      expect(directive.name).to eq('report-uri')
      expect(directive.value)
        .to eq(['https://logs.templarbit.com/csp/foobar/reports'])
    end
  end

  context 'when token contains deprecated directive' do
    let(:token) { 'reflected-xss allow' }

    it 'creates new valid directive' do
      expect(directive.name).to eq('reflected-xss')
      expect(directive.value).to eq(['allow'])
    end
  end

  context 'when token contains fully deprecated directive' do
    let(:token) { 'policy-uri policy.xml' }

    it 'throws DirectiveNameDeprecated error' do
      expect { directive }.to raise_error(CSPUtil::DirectiveNameDeprecated)
    end
  end

  context 'when token contains unknown directive' do
    let(:token) { 'foo bar' }

    it 'throws DirectiveNameUnknown error' do
      expect { directive }.to raise_error(CSPUtil::DirectiveNameUnknown)
    end
  end

  describe '#same_name?' do
    context 'when directive names are the same' do
      let(:directive_one) { described_class.new("base-uri 'none'") }
      let(:directive_two) { described_class.new("base-uri 'localhost'") }

      it 'returns true' do
        expect(directive_one.same_name?(directive_two)).to eq(true)
      end

      context 'when directive names are in the different registries' do
        let(:directive_one) { described_class.new("BASE-URI 'none'") }
        let(:directive_two) { described_class.new("base-uri 'localhost'") }
      end
    end

    context 'when directive names are different' do
      let(:directive_one) { described_class.new("base-uri 'none'") }
      let(:directive_two) { described_class.new("object-src 'self'") }

      it 'returns false' do
        expect(directive_one.same_name?(directive_two)).to eq(false)
      end
    end
  end
end
