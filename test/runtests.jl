using PQPolygonSDK
using Test

# -- Default test ------------------------------------------------------ #
function default_pqpolygonsdk_test() 
    return true
end
# ------------------------------------------------------------------------------- #

@testset "default_test_set" begin
    @test default_pqpolygonsdk_test() == true
end