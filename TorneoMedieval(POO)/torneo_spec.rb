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

    describe "Los objetos son comparables " do
        it "son mayores segun el numero de victorias" do
            @caballero2 = Caballero.new("Pepe", :medieval, 256, 9.6)
            expect(@caballero <=> @caballero2).to be(1)
        end
    end

    describe "Podemos saber que casa lo hace mejor" do
        it "para un array de 5 caballeros" do
            @caballeros = [
                Caballero.new("Pepe", :medieval, 256, 9.6),
                Caballero.new("Isabel", :stark, 123, 6.9),
                Caballero.new("Roberto", :stark, 256, 7.4),
                Caballero.new("Ana", :targaryen, 456, 7.5),
                Caballero.new("Juan", :medieval, 678, 8.1)
            ]
            expect(@caballero.mejor_casa(@caballeros)).to eq(:medieval)
        end
    end

    describe "Podemos saber quienes entran en la guardia real" do
        it "para un array de 5 caballeros" do
            @caballeros = [
                Caballero.new("Pepe", :medieval, 256, 9.6),
                Caballero.new("Isabel", :stark, 123, 6.9),
                Caballero.new("Roberto", :stark, 256, 7.4),
                Caballero.new("Ana", :targaryen, 456, 7.5),
                Caballero.new("Juan", :medieval, 678, 8.1)
            ]
            expect(@caballero.guardia_real(@caballeros)).to eq([
                "Pepe (medieval)",
                "Lancelot (stark)",
                "Juan (medieval)"
            ])
        end
    end
end