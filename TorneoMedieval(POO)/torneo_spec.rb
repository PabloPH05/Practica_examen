require 'rspec'
require_relative 'torneo'

RSpec.describe Caballero do
    before :each do
        @caballero = Caballero.new("Lancelot", :stark, 367, 8.9)
    end

    describe "#initialize" do
        it "creates a Caballero with the correct attributes" do
            expect(@caballero.nombre).to eq("Lancelot")
            expect(@caballero.casa).to eq(:stark)
            expect(@caballero.victorias).to eq(367)
            expect(@caballero.fuerza).to eq(8.9)
        end
    end
end