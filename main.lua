Particles = {}
MaxParticles = 1000
CurrentParticle = 1
SpawnTimer = 0.0
T = 0
START_Y = 200
PoleOffset = 100
-- Poles will be at Y = START_Y +/- offset and  Z = +/- PoleOffset
Frequency = 2.0
Offset = 100.0
Voltage = 250000.0
Collisions = {}
Rejections = {}
Spawned = {}


function NewParticle()
    local y = 1 * math.random() + START_Y
    local x = math.random() + math.random() * 10
    local z = 1 * math.random()
    local dy = 0.0
    local dx = 25.0
    local dz = 0.0
    local rigid = math.random(10)
    if Spawned[rigid] ~= nil then
        Spawned[rigid] = Spawned[rigid] + 1
    else
        Spawned[rigid] = 1
    end
    return {x=x, y=y, z=z, dx=dx, dy=dy, dz=dz, rigid=rigid}
end

function love.load()

end

function love.draw()
    for i,n in pairs(Collisions) do
        love.graphics.print(string.format("%d, %d", i, n), 10 + i*50 ,20)
    end
    for i,n in pairs(Rejections) do
        love.graphics.print(string.format("%d, %d", i, n), 10 + i*50 ,40)
    end
    for i,n in pairs(Spawned) do
        love.graphics.print(string.format("%d, %d", i, n), 10 + i*50 ,60)
    end
    love.graphics.print((Voltage)/(Offset + T/100), 10, 80)
    love.graphics.line(599,150,599,250)
    for _, particle in pairs(Particles) do
        if particle ~= nil then
            love.graphics.circle("fill", particle.x, particle.y,2)
        end
    end
end

function love.update(dt)


    local ac = Voltage

    local dc = Offset + T

    T = T + dt
    SpawnTimer = SpawnTimer + dt
    if SpawnTimer > 1.0 then
        Particles[CurrentParticle] = NewParticle()
        CurrentParticle = (CurrentParticle % MaxParticles) + 1
        SpawnTimer = 0.0
    end


    local c12 = (math.cos(Frequency*T))*ac + dc
    local c34 = (-math.cos(Frequency*T))*ac - dc



    for i, particle in pairs(Particles) do
        if particle == nil then
            goto continue
        end
        particle.x = particle.x + particle.dx * dt
        particle.y = particle.y + particle.dy * dt
        particle.z = particle.z + particle.dz * dt

        if particle.x > 599 then
            if particle.y < 250 and particle.y > 150 and particle.z > -50 and particle.z < 50 then
                if Collisions[particle.rigid] ~= nil then
                Collisions[particle.rigid] = Collisions[particle.rigid] + 1
                else
                    Collisions[particle.rigid] = 1
                end
            else 
                if Rejections[particle.rigid] ~= nil then
                Rejections[particle.rigid] = Rejections[particle.rigid] + 1
                else
                    Rejections[particle.rigid] = 1
                end
            end
            Particles[i]=nil        
            goto continue
        end

        local d1 = ((-100.0 - particle.z)^2+(300.0 - particle.y)^2)
        if d1 < 10 then            
            if Rejections[particle.rigid] ~= nil then
                Rejections[particle.rigid] = Rejections[particle.rigid] + 1
            else
                Rejections[particle.rigid] = 1
            end
            Particles[i]=nil        
            goto continue
        end
        local d2 = ((100.0 - particle.z)^2+(100.0 - particle.y)^2)
        if d2 < 10 then
            if Rejections[particle.rigid] ~= nil then
                Rejections[particle.rigid] = Rejections[particle.rigid] + 1
            else
                Rejections[particle.rigid] = 1
            end
            Particles[i]=nil        
            goto continue
        end
        local d3 = ((100.0 - particle.z)^2+(300.0 - particle.y)^2)
        if d3 < 10 then
            if Rejections[particle.rigid] ~= nil then
                Rejections[particle.rigid] = Rejections[particle.rigid] + 1
            else
                Rejections[particle.rigid] = 1
            end
            Particles[i]=nil        
            goto continue
        end
        local d4 = ((-100.0 - particle.z)^2+(100.0 - particle.y)^2)
        if d4 < 10 then
            if Rejections[particle.rigid] ~= nil then
                Rejections[particle.rigid] = Rejections[particle.rigid] + 1
            else
                Rejections[particle.rigid] = 1
            end
            Particles[i]=nil        
            goto continue
        end
        local sqrt_inv_d1 = 1.0 / math.sqrt(d1)
        local d1_z = (-100.0 - particle.z) * sqrt_inv_d1
        local d1_y = (300.0 - particle.y) * sqrt_inv_d1

        local sqrt_inv_d2 = 1.0 / math.sqrt(d2)
        local d2_z = (100.0 - particle.z) * sqrt_inv_d2
        local d2_y = (100.0 - particle.y) * sqrt_inv_d2


        local sqrt_inv_d3 = 1.0 / math.sqrt(d3)
        local d3_z = (100.0 - particle.z) * sqrt_inv_d3
        local d3_y = (300.0 - particle.y) * sqrt_inv_d3
        
        local sqrt_inv_d4 = 1.0 / math.sqrt(d4)
        local d4_z = (-100.0 - particle.z) * sqrt_inv_d4
        local d4_y = (100.0 - particle.y) * sqrt_inv_d4

        particle.dy = particle.dy + 
        (c12 * (d1_y/d1 + d2_y/d2) + c34 * (d3_y/d3 + d4_y/d4))/particle.rigid

        particle.dz = particle.dz + 
        (c12 * (d1_z/d1 + d2_z/d2) + c34 * (d3_z/d3 + d4_z/d4))/particle.rigid


        ::continue::
    end



end
