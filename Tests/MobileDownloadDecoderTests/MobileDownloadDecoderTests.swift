import XCTest
import MoneyAndExchangeRates
import MobileDownload
@testable import MobileDownloadDecoder


final class MobileDownloadDecoderTests: XCTestCase {
//    func testExample() {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct
//        // results.
//        XCTAssertEqual("Hello, World!", "Hello, World!")
//    }
//
//    static var allTests = [
//        ("testExample1", testExample),
//    ]


    //    func testPerformanceWithC() throws {
    //        self.measure {
    //            _ = RawReaderForEncodedMobileDownloadUsingC.getSections(fileUrl: demoDownloadFileName)
    //        }
    //    }
    //
    //    func testPerformanceWithSwift() throws {
    //        self.measure {
    //            _ = RawReaderForEncodedMobileDownload.getSections(fileUrl: demoDownloadFileName)
    //        }
    //    }

    func testCasesPerLayerParserEmpty() {
        XCTAssertNil(ItemRecord.decodeCasesPerLayerEntries(blob: ""))
        XCTAssertNil(ItemRecord.decodeCasesPerLayerEntries(blob: " "))
    }

    func testCasesPerLayerParser() {
        let blob = "2,7;10,10"

        let entries = ItemRecord.decodeCasesPerLayerEntries(blob: blob)
        XCTAssertNotNil(entries)

        XCTAssertEqual(entries!.count, 2)

        let firstEntry = entries!.first!

        XCTAssertEqual(firstEntry.palletSizeNid, 2)
        XCTAssertEqual(firstEntry.casesPerLayer, 7)
    }

    func testWarehouseCanSellService() {
        let sellableAltPackFamilyNids = [1001]
        let altPackFamilyNidsByItemNid = [101: 1001, 102: 1001]

        let warehouseSellabilityOverridesBlob = "6,101,0,0,0,0;6,102,1,1,0,0;6,103,1,1,1,1"
        let warehouseSellabilityOverrides = WarehouseRecord.decodeWarehouseSellabilityOverrides(warehouseSellabilityOverridesBlob)

        let service = WarehouseCanSellService(sellableAltPackFamilyNids: sellableAltPackFamilyNids,
                                              warehouseSellabilityOverrides: warehouseSellabilityOverrides,
                                              getAltPackFamilyNid: { altPackFamilyNidsByItemNid[$0] ?? $0 })

        XCTAssertEqual(service.canSell(itemNid: 101), false)
        XCTAssertEqual(service.canSample(itemNid: 102), false)
        XCTAssertEqual(service.canBuy(itemNid: 103), false)
    }

    func testWarehouseSellabilityOverrideService() throws {
        let warehouseSellabilityOverridesBlob = "6,101,0,0,0,0;6,102,1,1,0,0;6,103,1,1,1,1"
        let warehouseSellabilityOverrides = WarehouseRecord.decodeWarehouseSellabilityOverrides(warehouseSellabilityOverridesBlob)
        let service = WarehouseSellabilityOverrideService(warehouseSellabilityOverrides)

        XCTAssertEqual(service.isCanBuyRestricted(itemNid: 101), true)
        XCTAssertEqual(service.isCanIssueRestricted(itemNid: 101), true)
        XCTAssertEqual(service.isCanSellRestricted(itemNid: 101), true)
        XCTAssertEqual(service.isCanSampleRestricted(itemNid: 101), true)

        XCTAssertEqual(service.isCanBuyRestricted(itemNid: 102), false)
        XCTAssertEqual(service.isCanIssueRestricted(itemNid: 102), false)
        XCTAssertEqual(service.isCanSellRestricted(itemNid: 102), true)
        XCTAssertEqual(service.isCanSampleRestricted(itemNid: 102), true)

        XCTAssertEqual(service.isCanBuyRestricted(itemNid: 103), false)
        XCTAssertEqual(service.isCanIssueRestricted(itemNid: 103), false)
        XCTAssertEqual(service.isCanSellRestricted(itemNid: 103), false)
        XCTAssertEqual(service.isCanSampleRestricted(itemNid: 103), false)
    }


    func testDownloadedAvailableOrderNumbers() {
        let availableTicketNumbersBlob = "12721406,12721599O12795000,12795199O1313774,1313799I1352000,1352199I"
        let range1 = 12_721_599 - 12_721_406 + 1
        let range2 = 12_795_199 - 12_795_000 + 1
        XCTAssertEqual(range1 + range2, 394)
        let orderNumbers = HandheldRecord.decodeAvailableOrderOrItemTransferNumbers(blob: availableTicketNumbersBlob, lookingFor: "O")
        XCTAssertEqual(orderNumbers.count, range1 + range2)
    }

    func testDownloadedAvailableItemTransferNumbers() {
        let availableTicketNumbersBlob = "12721406,12721599O12795000,12795199O1313774,1313799I1352000,1352199I"
        let range1 = 1_313_799 - 1_313_774 + 1
        let range2 = 1_352_199 - 1_352_000 + 1
        XCTAssertEqual(range1 + range2, 226)
        let orderNumbers = HandheldRecord.decodeAvailableOrderOrItemTransferNumbers(blob: availableTicketNumbersBlob, lookingFor: "I")
        XCTAssertEqual(orderNumbers.count, range1 + range2)
    }

    func testCompanyItemEntries() {
        let odomData = "0,0,1;1,0,1;2,0,1;3,0,1;4,0,1;5,0,5;6,0,1;7,0,3;8,0,1;9,0,1;10,0,1;11,0,4;12,0,4;13,0,4;14,0,4;15,0,4;16,0,4;17,0,4;18,0,4;19,0,4;20,0,1;21,0,1;22,0,1;23,0,1;24,0,2;25,0,3;26,0,3;27,0,1;29,0,1;0,9,1;0,16,2;0,1203,5;0,1209,3;1,9,1;3,9,1;6,9,1;7,9,1;8,9,1;9,9,1;21,9,1;22,9,1;23,9,1;25,9,1;26,9,1;27,9,1;29,9,1;1,16,2;6,16,2;8,16,2;24,16,2;27,16,2;29,16,2;5,1203,5;6,1203,1;8,1203,1;23,1203,1;6,1209,3;7,1209,3;8,1209,3;9,1209,3;23,1209,3;25,1209,3;26,1209,3;27,1209,3;29,1209,3;6,1384,3;7,1384,3;8,1384,3;9,1384,3;23,1384,3;25,1384,3;26,1384,3;27,1384,3;29,1384,3;26,16,2"

        let entries = HandheldRecord.decodeCompanyItemEntries(fromBlob: odomData)

        XCTAssertEqual(entries.count, 75)
        let lastEntry = entries.last!
        XCTAssertEqual(lastEntry.companyNid, 2)
        XCTAssertEqual(lastEntry.hostWhseNid, 26)
        XCTAssertEqual(lastEntry.productSetNid, 16)
    }
    
    func testRetailInitiativeParser() {
        let xml = """
        <Sections>

        <Section Description="Display ideas" Sequence="0">
        <Items>
        <DocumentItem Sequence="0" Description="4th of July theme" DocumentURL="http://www.wiki-eostar.com/images/2/2d/Eagle_800.jpg" />
        <DocumentItem Sequence="1" Description="Retailer specific theme" DocumentURL="http://www.wiki-eostar.com/images/8/87/Retailerthem3_800.JPG" />
        <DocumentItem Sequence="2" Description="Patriotic theme" DocumentURL="http://www.wiki-eostar.com/images/7/7e/USA_800.JPG" />
        <DocumentItem Sequence="3" Description="Seasonal package" DocumentURL="http://www.wiki-eostar.com/images/4/4c/Pepsipackage_700.jpg" />
        </Items>
        </Section>

        <Section Description="Incentive program" Sequence="1">
        <Items>
        <ObjectiveItem Sequence="0" Description="Display objective" ObjectiveTypeNid="1" ObjectiveStartDate="2019-05-21" ObjectiveDueByDate="2019-06-07" SqlDescription="Sell in Swing into Summer display" />
        </Items>
        </Section>

        <Section Description="Marketing support" Sequence="2"><Items>
        <DocumentItem Sequence="0" Description="Swing into Summer Ad" DocumentURL="https://www.youtube.com/embed/OIFkRl07Dfg" />
        </Items>
        </Section>

        </Sections>
        """


        let parser = RetailInitiativeXMLDecoder()
        let sections = parser.parse(xml: xml)

        XCTAssertEqual(sections.count, 3)
        XCTAssertEqual(sections[0].description, "Display ideas")
        XCTAssertEqual(sections[0].items.count, 4)
        XCTAssertEqual(sections[1].items.count, 1)
        XCTAssertEqual(sections[2].items.count, 1)

        let objectiveItem = sections[1].items[0] as? RetailInitiative.Objective
        XCTAssertNotNil(objectiveItem)
        if let objectiveItem = objectiveItem {
            XCTAssertEqual(objectiveItem.objectiveTypeNid, 1)
        }
    }

    
    func testAbsenceOfSpecialPrices() throws {
        let blob = ""
        let prices = CusSpecialPricesDecoder.decodeSpecialPrices(blob: blob)
        XCTAssertNil(prices)
    }

    func testSimpleSpecialPrice() throws {
        let blob = "20201217s250p1001i" // starting on 12/17/2020 item 1001 will sell for 2.50

        let prices = CusSpecialPricesDecoder.decodeSpecialPrices(blob: blob)
        XCTAssertNotNil(prices)
        XCTAssertEqual(prices?.count, 1)
        let first = prices!.first!
        XCTAssertEqual(first.startDate, Date.fromyyyyMMdd("20201217"))
        XCTAssertNil(first.endDate)
        XCTAssertEqual(first.price.decimalValue, 2.50)
        XCTAssertEqual(first.itemNid, 1001)

        XCTAssertFalse(first.isPriceActive(date: Date.fromyyyyMMdd("20201216")!))
        XCTAssertTrue(first.isPriceActive(date: Date.fromyyyyMMdd("20201217")!))
    }

    func testPromoItemDecoder() throws {
        let date = Date.fromyyyyMMdd("20210203") ?? Date.distantPast
        XCTAssertEqual(date.toLocalTimeDescription(), "2021-02-03 00:00:00")

        let blob = "'hi mike'' and Ann'n-12500a20210203r13i"

        let itemsAndNote = PromoItemDecoder.getPromoItemsAndNote(blob: blob, promoSectionNid: 999)

        XCTAssertEqual(itemsAndNote.getNote(promoSectionRecNid: 1), "hi mike\' and Ann")
        let firstPromoItem = itemsAndNote.getPromoItems(promoSectionRecNid: 1, promoDate: date).first!

        XCTAssertEqual(firstPromoItem.itemNid, 13)
        XCTAssertEqual(firstPromoItem.promoRate, -12500)
        XCTAssertEqual(firstPromoItem.promoRateType, PromoItem.ePromoRateType.amountOff)
        XCTAssertEqual(firstPromoItem.thruDateOverride, date)
    }

    func testPriceSheetDecoder() throws {
        let pricesBlob = "192a2230I2304a916I2400a2029I2178I2800a2115I3177I3178I3179I2960a1997I1999I2000I2001I2002I2003I2004I2005I2006I2007I2008I2009I2054I2135I2137I2147I2157I2450I2451I2452I2453I2454I2455I2936I2983I3185I3214I3215I3216I3567I3000a3107I3108I3200a2108I2109I2279I2280I2281I2282I2283I2351I2361I3600a3426I3760a2090I4560a2409I2410I4960a2458I2459I3248I3254I3255I5040a2966I3181I3211I5120a3209I5200a3194I5280a2585I5360a2577I2578I5960a2810I6000a2709I2742I2798I2916I3125I3126I3128I6100a3098I6320a2340I2341I2342I2343I3102I3132I3186I3221I3223I6900a2511I7280a2457I3253I7440a3743I3744I8300a2509I2510I8320a2251I2317I2349I2350I2403I2404I2460I2461I2462I2463I2464I2465I2466I2467I2468I2469I2470I2471I2472I2473I2476I2478I2479I2480I2506I2507I2508I2539I2540I8560a2257I2258I2259I9040a3048I3049I3051I9360a2912I2931I2932I9440a2241I2242I2243I2244I2245I2246I2247I2250I2260I2261I2262I2331I2367I2419I2420I2421I2422I2423I2424I2425I3745I9600a2911I2913I10000a2951I2952I2954I2955I10200a2586I2587I2588I2589I2590I2591I2592I2593I2596I10960a2947I11120a1979I2267I2456I3250I3251I11440a2266I11520a2071I2072I2102I2107I2205I2206I2320I2324I2325I2326I2327I2328I2329I2330I11600a2805I3135I3136I3137I3436I11760a3047I11920a2730I12000a2956I12960a2426I2427I2428I2429I2431I2432I13000a2430I14960a3187I3188I15000a2781I3428I15600a3433I16000a3103I3112I17200a2015I3089I3096I3099I3244I3380I17600a3498I18480a3090I3095I3100I18490a3101I18560a2040I2041I2042I2043I2046I2047I2048I2049I2098I18960a2074I2075I2436I2437I2438I2439I19200a2231I2232I2233I2332I3160I3161I3162I3210I3213I19360a3594I3595I19520a2181I19920a1991I2070I2079I2080I2081I2082I2084I2118I2121I2218I2219I2276I2277I2302I2305I2306I2313I2314I2315I2316I2357I2358I2442I2498I2534I2535I2926I2943I2944I2945I2946I2960I2971I2972I2990I3183I3208I3649I20000a2567I2584I2595I2598I2599I2600I2601I2602I2889I2903I2904I2905I20080a2010I2059I2077I2144I2145I2176I2177I2201I2229I2240I2359I2360I3306I3468I3790I3791I3793I3795I20240a2035I2036I2037I2050I2051I2097I2189I2190I2268I20960a1987I1988I2057I21120a2512I2513I2514I3703I3704I3705I3706I3710I21200a3121I3127I3357I21280a1946I1947I1948I2011I2012I2013I2014I2194I2200I2202I2203I2237I2238I2292I2345I2346I2368I2369I2370I2371I2372I2378I2391I2392I2393I2394I2402I2435I2496I2516I2522I2523I2550I2551I2800I2847I3157I3158I3166I3168I3171I3172I3173I3405I3432I3469I21360a2086I2485I2486I3217I3218I3219I3220I21520a2227I2295I2296I2434I2504I2505I2547I2548I2973I2974I2978I2979I2980I2991I21680a2210I2364I2365I3396I3399I3401I3403I3404I21840a2099I2117I2182I2183I2195I2204I2217I2284I2285I2286I2310I2348I2433I2481I2482I2483I2494I2495I2524I2549I3002I3003I3155I3156I3164I3165I3170I3202I3203I21870a2525I22320a2376I2489I2490I2491I2492I2493I2497I2526I2527I22400a2076I2119I2120I2235I2236I2301I2406I2475I2517I2552I3434I3437I3438I3442I22960a2221I2222I2278I2397I2398I3356I23120a2274I2275I3195I23200a2377I23840a2553I24072a3349I24720a2521I3347I3348I25200a1503I2016I2017I2018I2019I2020I2021I2022I2023I2024I3046I25520a2166I2167I2308I2309I2395I2396I27120a3424I3427I27360a2501I2502I2503I28000a820I28720a2234I3332I3355I28800a1318I1472I1473I1474I1475I1476I1489I1490I1497I1498I29120a2209I2311I2312I2362I2363I2533I30960a2220I35200a2536I2537I35520a894I1334I1420I1421I1422I1423I1424I1425I1435I1436I1437I1443I1863I38160a2125I2126I2318I2333I39680a1036I1037I1048I1052I1053I40000a3804I41040a1480I1481I41360a3386I3408I43120a3385I45360a1504I1511I45600a2597I46000a2223I2224I2477I51100a2499I2500I51120a2411I2412I2413I2415I2519I2545I2555I2556I55200a1054I71920a807I74880a1508I1509I76000a2914I85280a809I86400a474I87360a1427I1442I88960a1050I1051I1448I90000a937I938I92160a441I103680a1038I1039I1040I1041I1043I1044I104000a1042I108480a836I837I838I112320a863I113280a1392I115200a862I864I120000a920I921I922I923I120960a929I121440a1006I1007I1008I122000a452I130080a996I133120a416I417I418I133440a1426I133920a426I427I136960a419I420I421I138240a896I904I905I1341I1345I1356I1357I1358I1359I1360I1361I1362I138720a1004I139200a847I141120a1445I143040a510I144000a473I508I522I523I524I144432a1000I147840a1449I1450I1454I147920a1455I148000a969I148320a998I999I1023I149760a422I423I151680a525I526I157920a963I160800a940I941I162720a1003I1010I165760a976I979I980I981I982I983I984I985I986I987I988I989I993I166400a454I167040a1496I1513I1514I1515I1516I1517I1518I1519I1520I169600a1452I1453I169920a428I172000a810I172320a1019I172480a960I172800a411I174000a403I404I405I174720a457I458I459I460I461I462I463I464I465I177600a1032I180000a844I857I182160a1467I1493I1494I1495I1521I1522I184000a957I958I959I187200a845I188800a453I455I456I189600a943I944I192000a841I197280a439I199680a489I490I491I492I493I506I507I521I924I202240a946I947I948I949I204000a443I444I445I446I447I448I449I450I451I206400a839I840I851I890I1802I208080a1468I1469I211200a871I213120a1035I214560a1506I216000a955I956I221760a964I223200a813I814I815I816I817I226560a488I499I500I501I502I503I504I505I511I512I513I514I515I516I517I520I227520a1347I1348I1413I1414I1415I1416I228960a1015I1016I1017I1018I229680a1470I1471I1482I1483I1491I1492I229760a1451I230400a917I918I919I1354I1429I1434I1793I1794I1795I232320a1803I1804I234240a1319I239040a870I1845I1846I1857I240000a414I859I860I861I1352I1855I1856I240960a875I885I895I912I915I1326I1332I1333I1350I248160a997I1001I249600a939I251520a892I893I252000a827I828I829I830I831I832I833I834I253440a877I878I879I881I1836I1837I1838I1864I255360a843I858I865I866I867I876I886I887I888I889I910I911I1323I1325I1327I1328I1371I1385I1386I1393I1394I1395I1396I1397I1398I1401I1402I1403I1404I1407I1412I1799I1809I1817I1818I1819I1820I1821I1822I1823I1824I1839I1841I1842I1852I1853I256320a1346I1438I1439I1440I1441I1813I1814I258240a913I1373I1374I1411I1825I1834I1835I1849I1850I1858I1859I1860I1861I1862I260160a852I854I855I856I898I1390I1391I262080a902I903I1320I1321I1324I1337I1338I1355I1363I1364I1365I1387I1410I1432I1433I1446I1447I1465I1466I1502I1507I1796I1797I1798I1807I1808I1810I1811I1812I1826I1827I1843I1851I262440a1844I267840a1806I268800a846I848I849I850I908I909I1335I1336I1349I1379I1409I1805I1840I1854I275520a899I900I1383I1405I1406I276480a471I278080a966I278400a509I278880a400I1876I1880I1881I1883I1885I1886I1887I1893I1894I1895I1896I1897I1898I1899I1900I1901I1902I1903I1904I1905I1906I1907I1908I1909I1910I1911I1912I1913I1914I1915I1916I1923I280000a1882I1888I1889I1890I1891I1892I286080a530I287200a818I293440a1875I299520a954I302400a891I1444I306600a1020I1021I306720a1011I1012I1013I1014I1022I1029I1030I1031I320320a933I328320a1831I1832I1833I334800a402I409I415I336000a1870I1871I345600a401I348000a410I349440a1388I1389I359040a931I932I361440a424I425I430I432I433I437I438I370000a1872I371520a897I380000a968I392000a802I410400a1510I413280a431I421680a468I469I422400a1847I1848I445200a467I448200a974I975I449280a971I972I973I467040a962I480000a961I576000a803I593920a805I655200a1873I665600a804I1912320a1526I"

        let prices = PriceSheetRecord.decodePricesBlob(pricesBlob: pricesBlob)

        XCTAssertEqual(prices.count, 1075)

        XCTAssertEqual(prices[1526]![0]!, MoneyWithoutCurrency(scaledAmount: 1_912_320, numberOfDecimals: 4))
    }

}
