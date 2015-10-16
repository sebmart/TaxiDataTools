using DataFrames

#polygon representing manhattan
city = [(40.87851017592601,-73.927903175354);(40.87743937506905,-73.92168045043945);(40.87516792197097,-73.91871929168701);(40.87393481479329,-73.91193866729736);(40.87182549927143,-73.90970706939697);(40.866016421491814,-73.91168117523193);(40.859655059077824,-73.91764640808105);(40.84855366761019,-73.9266586303711);(40.84394377141786,-73.92949104309082);(40.83550228531863,-73.9339542388916);(40.82816381252365,-73.9339542388916);(40.81972031701224,-73.93318176269531);(40.808677200957106,-73.93335342407227);(40.801920506109774,-73.92803192138672);(40.7958778790764,-73.92820358276367);(40.78210123234386,-73.94107818603516);(40.77547182731999,-73.93953323364258);(40.7701418259051,-73.94588470458984);(40.75831029512206,-73.95669937133789);(40.744395800976775,-73.96888732910156);(40.71746884168838,-73.97077560424805);(40.70927151739564,-73.9764404296875);(40.7066689811733,-73.99497985839844);(40.697299008636755,-74.01008605957031);(40.69899090674371,-74.02381896972656);(40.74907763805906,-74.01351928710938);(40.77950154452169,-73.99532318115234);(40.81822635589172,-73.96751403808594);(40.853163243121564,-73.94845962524414)]

months = collect(1:12)
days = Vector{Int}[
collect(7:13), collect(2:2), collect(1:8), collect(1:10), collect(1:8), collect(1:16),
collect(1:0), collect(1:0), collect(1:0), collect(1:0), collect(1:0), collect(1:0)
]

#keep points in the dataset only if inside manhattan
function point_inside_polygon(x,y,poly)
    n = length(poly)
    inside =false

    p1x,p1y = poly[1]
    for i in 0:n
        p2x,p2y = poly[i % n + 1]
        if y > min(p1y,p2y)
            if y <= max(p1y,p2y)
                if x <= max(p1x,p2x)
                    if p1y != p2y
                        xinters = (y-p1y)*(p2x-p1x)/(p2y-p1y)+p1x
                    end
                    if p1x == p2x || x <= xinters
                        inside = !inside
                    end
                end
            end
        end
        p1x,p1y = p2x,p2y
    end
    return inside
end
for month in months, day in days[month]
    df = readtable(@sprintf("data/2013-%02i-%02i.csv",month,day))
    @printf("2013-%02i-%02i\n",month,day)
    println("original length: $(nrow(df))")
    mask = [point_inside_polygon(df[i,:plat],df[i,:plong],city) &&
     point_inside_polygon(df[i,:dlat],df[i,:dlong],city) for i in 1:nrow(df)]
    df = df[mask,:]
    println("final length: $(nrow(df))")
    writetable(@sprintf("data/2013-%02i-%02i.csv",month,day), df)
end
