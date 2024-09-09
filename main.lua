Particles = {}
MaxParticles = 1000
CurrentParticle = 1
SpawnTimer = 0.0
T = 0
START_Y = 200
PoleOffset = 100
PoleOffsetSq = PoleOffset^2

R_0sq = 1/PoleOffset^2
Frequency = 30.0
Offset = 230.0
Voltage = 1600.0


function ZeroDefault (t)
    local mt = {__index = function () return 0 end}
    setmetatable(t, mt)
end
Collisions = {}
RejectionsY = {}
RejectionsZ = {}
Spawned = {}
ZeroDefault(Collisions)
ZeroDefault(RejectionsY)
ZeroDefault(RejectionsZ)
ZeroDefault(Spawned)
Mode = "uniform"

function NewRigidity(mode)
    if mode == "uniform" then
        return math.random(100)
    end
    if mode == "sparse" then
        return math.random(10)*10
    end
    return mode
end
function NewParticle()
    local y = 0.01*math.random() - 0.005
    local x = 0
    local z = 0.01*math.random() - 0.005
    local dy = 0.0
    local dx = 100.0
    local dz = 0.0
    local rigid = NewRigidity(Mode)
    Spawned[rigid] = Spawned[rigid] + 1
    return {x=x, y=y, z=z, dx=dx, dy=dy, dz=dz, rigid=rigid}
end

function love.load()
end

function love.draw()
    for i=1,100 do
        love.graphics.circle("fill", 10+4*i, 50 - 40*(Collisions[i]/Spawned[i]),2)
        love.graphics.setColor(1, 0, 0)
        love.graphics.circle("fill", 10+4*i, 100 - 40*(RejectionsY[i]/Spawned[i]),2)
        love.graphics.setColor(0, 0, 1, 0.5)
        love.graphics.circle("fill", 10+4*i, 100 - 40*(RejectionsZ[i]/Spawned[i]),2)
        love.graphics.setColor(1, 1, 1)
    end
    love.graphics.print(string.format("Freq: %6.1f", Frequency), 10, 110)
    love.graphics.print(string.format("AC: %.4d", Voltage), 150, 110)
    love.graphics.print(string.format("DC: %4.d", Offset), 300, 110)
    love.graphics.print(Mode, 450, 110)

    love.graphics.line(599,150,599,250)
    love.graphics.line(599,350,599,450)

    for _, particle in pairs(Particles) do
        if particle ~= nil then
            love.graphics.print(string.format("%d", particle.rigid), particle.x, 300)

            love.graphics.circle("fill", particle.x, particle.y+200,2)
            love.graphics.circle("fill", particle.x, particle.z+400,2)
        end
    end
end

function love.keypressed(key, scancode, isrepeat)
    if scancode == "q" then
        Frequency = Frequency + 0.1
    end
    if scancode == "a" then
        Frequency = Frequency - 0.1
    end
    if scancode == "w" then
        Voltage = Voltage + 100.0
    end
    if scancode == "s" then
        Voltage = Voltage - 100.0

    end
    if scancode == "e" then
        Offset = Offset + 10.0

    end
    if scancode == "d" then
        Offset = Offset - 10.0

    end
    if scancode == "p" then
        love.graphics.captureScreenshot(string.format("Freq%.1fAC%.4dDC%.d.png", Frequency, Voltage, Offset))
    end

    if scancode == "o" then
        Collisions = {}
        RejectionsY = {}
        RejectionsZ = {}
        Spawned = {}
        Particles = {}
        ZeroDefault(Collisions)
        ZeroDefault(RejectionsY)
        ZeroDefault(RejectionsZ)
        ZeroDefault(Spawned)
    end

    if scancode == "r" then
        if Mode == "uniform" then
            Mode = 100
        elseif Mode == "sparse" then
            Mode = "uniform"
        elseif Mode == 1 then
            Mode = "sparse"
        else
            Mode = Mode - 1
        end
        
    end
    if scancode == "f" then
        if Mode == "uniform" then
            Mode = "sparse"
        elseif Mode == "sparse" then
            Mode = 1
        elseif Mode == 100 then
            Mode = "uniform"
        else
            Mode = Mode + 1
        end
    end
end

function love.update(dt)

    T = T + dt
    SpawnTimer = SpawnTimer + dt
    if SpawnTimer > 0.05 then
        Particles[CurrentParticle] = NewParticle()
        CurrentParticle = (CurrentParticle % MaxParticles) + 1
        SpawnTimer = 0.0
    end


    local FieldStrength = Offset - Voltage * math.cos(Frequency * T)


    for i, particle in pairs(Particles) do
        if particle == nil then
            goto continue
        end

        if particle.z^2 + particle.y^2 > PoleOffsetSq then
            if math.abs(particle.z) > math.abs(particle.y) then 
                RejectionsZ[particle.rigid] = RejectionsZ[particle.rigid] + 1
            else
                RejectionsY[particle.rigid] = RejectionsY[particle.rigid] + 1
            end
            Particles[i] = nil
            goto continue
        end
        
        if particle.x > 599 and particle.z^2 + particle.y^2 < (10000) then
            Collisions[particle.rigid] = Collisions[particle.rigid] + 1
            Particles[i] = nil
            goto continue
        end

        particle.x = particle.x + particle.dx * dt
        particle.y = particle.y + particle.dy * dt
        particle.z = particle.z + particle.dz * dt

        local d_2z = -200*R_0sq * FieldStrength * particle.z / particle.rigid
        local d_2y = 200*R_0sq * FieldStrength * particle.y / particle.rigid

        particle.dz = particle.dz + d_2z
        particle.dy = particle.dy + d_2y


        ::continue::
    end



end
