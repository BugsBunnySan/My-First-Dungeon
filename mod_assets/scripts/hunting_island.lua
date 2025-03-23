function init()
end

function sky_disable(sky)
    sky.model:disable()
    sky.nightSky:disable()
    sky.stars:disable()
    sky.light:disable()
    sky.ambient:disable()
    sky.sky:disable()
    sky.lensflare:disable()
    if sky.forgparticles ~= nil then
        sky.forgparticles:disable()
    end
end

function sky_enable(sky)
    sky.model:enable()
    sky.nightSky:enable()
    sky.stars:enable()
    sky.light:enable()
    sky.ambient:enable()
    sky.sky:enable()
    sky.lensflare:enable()
    if sky.forgparticles ~= nil then
        sky.forgparticles:enable()
    end
end

function swampSky()
    sky_enable(hunting_island_swamp_sky)
    sky_disable(hunting_island_forest_sky)
end

function forestSky()
    sky_enable(hunting_island_forest_sky)
    sky_disable(hunting_island_swamp_sky)
end