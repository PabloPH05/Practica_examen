require 'rspec'
require_relative 'videojuegos'

RSpec.describe Videojuegos do
    before(:each) do 
        @video = Videojuegos::Videojuego.new("League of Legends", :moba, 0.0, {region: :eu, cantidad: 100})
    end

    context "Pruebas de atributos" do
        it "deberia tener un nombre" do
            expect(@video.titulo).to eq("League of Legends")
        end

        it "deberia tener un genero" do
            expect(@video.genero).to eq(:moba)
        end

        it "deberia tener una calificacion" do
            expect(@video.precio).to eq(0.0)
        end

        it "deberia tener servidores" do
            expect(@video.ventas).to eq({region: :eu, cantidad: 100})
        end
    end
end