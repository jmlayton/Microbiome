README for manuscript "Soil abiotic variables are more important than plant phylogeny or habitat specialization in determining soil microbial community structure"
doi:10.5061/dryad.5f24ks4


The taxonomic group and fungal guilds included in this RData are:
Fungi (ITS)
Archaea (16S)
Bacteria (16S)
#as subsets of the fungal otu table, determined by FUNGuild:
Arbuscular mycorrhizal fungi (ITS)
Ectomycorrhizal fungi (ITS)
Saprotrophic fungi (ITS)
Pathogenic fungi (ITS)
	#These fungal guilds can have the same OTU assigned to more than one functional guild (i.e. both ECM and Saprotrophic)


Each group/guild has 4 datasets: a RAREFIED OTU table, a taxonomy table, sample metadata, and a phyloseq object combining the three separate datasets.

OTU table Information
The ITS and 16S (bacteria & archaea) OTU tables were rarefied to the lowest sample size that retained the most samples (2013 for ITS, 1028 for 16S). 
Then, the ITS and 16S OTU tables were subsetted to the groups listed above. Raw data is available from the NCBI Short Reads Archive, PRJNA430283: SAMN08368913-SAMN08369068 for ITS and SAMN08372547-SAMN08372761 for 16S
OTU table row names = sample names (each willow plant sampled)
OTU table column names = OTU ID #

Taxonomy tables - see manuscript for taxonomy assignment methods

Sample data tables information
Column name descriptions
GardenID - identification number of Garden + treatment (D=upland, W=wetland)
Garden.Location - garden site
Number - identification number for paired gardens
Treatment - D= upland garden, W=wetland garden
June -  water table depth, measured once for June
July -  water table depth, measured once for July
Aug	-  water table depth, measured once for August
Mean - average of the water table depth for June, July and August	
Nmin - N mineralized (mg N/kg soil/day), calculated as N mineralized = [(Nitrate_final + Ammonium_final) - (Nitrate_initial + Ammoinium_initial)] / time
		One time interval, May-June was measured for each wet and dry garden, and dry gardens were also measured for a July-August interval
NO3	- Nitrate, 2M KCl extracted, determined with the vanadium method,  measured at the garden level in May
NH4 - Ammonium, 2M KCl extracted,detemined by the salicylate method, measured at the garden level in May
pH	- average of the pH measured at the garden level in May and August
Spp	- Willow Species that soils were sampled under: upland specialists, S. interior [INT], S. humilis [HUM], P. deltoides [DEL]), wetland specialists (S. lucida [LUC], S. serissima [SER], S. nigra [NIG], S. pyrifolia [PYR], S. pedicellaris [PED], S. candida [CAN]), and generalists (S. discolor [DIS], S. petiolaris [PET], S. eriocephala [ERI], S. bebbiana [BEB], S. amygdaloides [AMY]
Ecology	 - Habitat specialization of each willow species determined by surveys of natural abundances at Cedar Creek(see above for generalists, upland or wetland specialist designations)
Sample	- sample name, matches OTU table sample names
Genotype - most willows were controlled for genotype
Caged.E..Not.Caged - See Wei et al. 2017, as part of a herbivory experiment some willows were caged in insect-excluding mesh. This was not a significant predictor in the present study.
Plant_Height_m	- height of each willow plant
Date_Sampled - date the soil samples were taken
extraction_date	- date the soil samples were extracted. Soil was stored frozen at -20 until extraction
Lat	-latitude of the garden (ie 1D, 1W, 2D ...)
Long -longitude of the garden	
Species	- long format species names
#The following are willow traits measured in the field and greenhouse by Jessica Savage and available from Cedar Creek ESR data repository: https://www.cedarcreek.umn.edu/research/data/dataset?aare238
TLP - Average turgor loss point in leaves (MPa)megapascal
WD - Average wood density (g/cm3)gramsPerCubicCentimeter
SPI - Average stomatal pore area per lamina areaporeAreaPerLaminaArea
LSV - Average lengeth of seed viability (weeks)dimensionless
RER - Average root elongation rate (cm/day)centimetersPerDay
SLA - Average specific leaf area (cm2/g)squareCentimetersPerGram
RGR - Average relative growth rate (g/g*day)gramsPerGramsPerDay
TLP.F - Field measured Average turgor loss point in leaves (MPa)megapascal
WD.F - Field measured Average wood density (g/cm3)gramsPerCubicCentimeter
SPI.F - Field measured stomatal pore area per lamina areaporeAreaPerLaminaArea
SLA.F - Field measured Average lengeth of seed viability (weeks)dimensionless