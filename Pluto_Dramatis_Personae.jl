### A Pluto.jl notebook ###
# v1.0.1

using Markdown
using InteractiveUtils

# ╔═╡ ec5d11c4-2bd3-4003-95c1-79eb4adedf67
using BetaReader

# ╔═╡ 6803fb60-4024-40d3-89a3-610b3caba42a
md"""
# Extract a *Dramatis Personae* from a CEX text

A demonstration of some basic methods for humanist computing.
"""

# ╔═╡ 7bc16f5c-a123-45a0-a210-f407d88dbb66
md"""

## 1. Reading a File into Data

"Get a bunch of things."

"""

# ╔═╡ ab1bf088-5aed-4398-b9f9-f233e6fc80d9
md"Where is the file?"

# ╔═╡ 4637d894-708e-11f1-b4d1-47c320d96d7b
text_path = "/Users/cblackwell/cite/Frogs_Summer_2026/Text/frogs-speech-speaker.cex"

# ╔═╡ dd5741f2-5ec7-4d89-9e3d-7f5848269c4a
md"Read in that file, liine by line."

# ╔═╡ da53747d-d3d3-4d99-85fe-8466206f41a4
file_as_lines = readlines(text_path)

# ╔═╡ d57bfe5d-d77c-4f28-9843-20b783b25d00
typeof(file_as_lines)

# ╔═╡ 31da7d95-eb1a-4fd2-aee3-ee10aba834fc
md"""

## 2. A Function, and Looping

- Learn a new task.
- Do something to everything.
- Get a subset of 'everything'.

"""

# ╔═╡ e602f9ad-7fc1-4830-8497-dadf6dd245ae
# This is a comment, by the way. 
# Declare a function and tell it to expect a Vector of Strings

function get_cts_data(lines::Vector{String})
    
    # Make an empty Vector to hold the data we want…
    data = Tuple{String,String}[]

    # We don't want every line, only those in the data-block.
    in_data_block = false

    # The Loop: Go through `lines` and look at each one, calling it `line`
    for line in lines

        # Get rid of white-space before or after the line
        line = strip(line)

        # Shorthand for "If the line is empty, skip everythings below and loop to the next one
        isempty(line) && continue

        # Start of a new block
        if startswith(line, "#!")
            
            # Being clever…
            in_data_block = (line == "#!ctsdata")
            
            # We don't want this one, regardless, so loop again…
            continue
        end

        # Only collect lines when we are inside a #!ctsdata block
        # Do a little validity checking, too.
        if in_data_block && occursin('#', line)

            # Get the two parts of the line; name them `urn` and `text`
            urn, text = split(line, '#'; limit=2)

            # Keep them!
            push!(data, (strip(urn), strip(text)))
        end
    end

    # After reading the whole file, send the keepers back to whoever asked for them.
    return data
end

# ╔═╡ e2499df2-bbcf-4d30-a091-94093ec3a117
md"Now that we have a function to get us our data, use it to get our data!"

# ╔═╡ e9986b55-1814-4049-a656-0610c31d13d2
cts_vector = get_cts_data(file_as_lines)

# ╔═╡ d26fafc6-022c-407f-add3-1ae9c3f86f76
cts_vector[2][2]

# ╔═╡ 803d93cd-87bc-4d4c-9788-ddc7befbd801
md"""

## 3. Filter

- Get a subset of 'everything'

"""

# ╔═╡ 77ad52d0-c403-4fa7-b03d-ceb112d2a797
# We filter out what we _don't_ want
just_speaker_lines = filter(cts_vector) do cex_tuple
	# Get the urn alone
	urn_part = cex_tuple[1]
	# Keep only ones with "speaker"
	contains(urn_part, "speaker")
end

# ╔═╡ 3205a6bb-f7ee-49a8-85d5-16531d7b1604
md"""

## 4. Map

- Do something to everything

"""

# ╔═╡ dd50253e-6fed-4a33-9bc8-4cc742ade9bf
just_speakers = map(just_speaker_lines) do cex_tuple
	cex_tuple[2]
end

# ╔═╡ 58218ba6-249a-4ea6-b6db-2e98c2401df5
md"""

## 5. Unique

- Summarize!
- A nice way to error-check.
- Keeping the text-order, so, this is our *Dramatis Personae*

"""

# ╔═╡ f40a0c14-b416-4224-9396-68b8d0554642
dram_pers = unique(just_speakers)

# ╔═╡ 3c587bf5-f28c-4edf-bb3d-0fc492476660
md"""

## 6. Histogram

- Summarize and count!
- What computers do best.

"""

# ╔═╡ c6890474-f545-4bd6-866d-69b8e51bae27
md"We'll make a new function to do this"

# ╔═╡ dcebf70e-89c7-41f7-9580-da0a85127e04
# The function takes a Vector of Strings
function histogram(data::Vector{String})

    # We're going to want a 'dictonary' consisting of an 'entry' (a String) and some information associated with it, in this case, a count (Integer)
    # It starts empty `()`
    counts = Dict{String, Int}()

    # Loop! Look at each bit of `data`, calling it `str`…
    for str in data

        # We'll break this down below.
        counts[str] = get!(counts, str, 0) + 1
    end
    sort(collect(counts), by = last, rev = true)
end

# ╔═╡ 364dd178-3d95-4ce8-80e8-0b9e53045f87
speaker_histo = histogram(just_speakers)

# ╔═╡ 3298fa0a-775e-478a-9d1f-bfd76a5f7163
typeof(speaker_histo)

# ╔═╡ 6e91e903-d211-4300-a7d3-a88a54e5b561
md"""

## 7. Format for Humans

- Make it pretty

"""

# ╔═╡ c7e643a3-92bf-4e15-92d6-c8e2d5156578


# ╔═╡ d933b5e5-627d-47de-80b9-313e7a6e2cd7
md"Get a code-library that knows a little about Greek."

# ╔═╡ 58053e2f-f6fb-4e52-b2a0-5e8307121012
md"Another `map()`, this one turning data from our histogram into Markdown strings for a human reader."

# ╔═╡ 294f3e9c-6f60-455e-9812-94895e87f3a3
md_dramatis_personae = map(speaker_histo) do speaker
	grk_speaker = speaker[1]
	lat_speaker1 = BetaReader.unicodeToLatinUnicode(grk_speaker)
	lat_speaker2 = replace(lat_speaker1, "u" => "y")
	lat_speaker3 = replace(lat_speaker2, "Ey" => "Eu")
	lat_speaker = replace(lat_speaker3, "oy" => "ou")
	line_count = speaker[2]
	"1. $grk_speaker (*$lat_speaker*): $line_count lines"
end

# ╔═╡ c2f42d0b-6127-4fb7-9077-54b06bd0e01a
output_path = "/Users/cblackwell/cite/Frogs_Summer_2026/Text/dramatis_personae.md"

# ╔═╡ 6beffdf9-efc6-49f2-865e-66818fc49f1c
open(output_path, "w") do f
        println(f, "# Dramatis Personae\n")
        for (md_line) in md_dramatis_personae
            println(f, md_line)
        end
    end

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
BetaReader = "e5583720-4bc8-44d1-bd9a-9734450b0166"

[compat]
BetaReader = "~2.2.3"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.12.6"
manifest_format = "2.0"
project_hash = "26062184b54e378fede7a66d25e95ef039eaa799"

[[deps.ANSIColoredPrinters]]
git-tree-sha1 = "574baf8110975760d391c710b6341da1afa48d8c"
uuid = "a4c015fc-c6ff-483c-b24f-f7ea428134e9"
version = "0.0.1"

[[deps.Adapt]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "daa72978cd7a624246e894a4f4f067706d4e17e2"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "4.7.0"

    [deps.Adapt.extensions]
    AdaptSparseArraysExt = "SparseArrays"
    AdaptStaticArraysExt = "StaticArrays"

    [deps.Adapt.weakdeps]
    SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
    StaticArrays = "90137ffa-7385-5640-81b9-e52037218182"

[[deps.AliasTables]]
deps = ["PtrArrays", "Random"]
git-tree-sha1 = "9876e1e164b144ca45e9e3198d0b689cadfed9ff"
uuid = "66dad0bd-aa9a-41b7-9441-69ab47430ed8"
version = "1.1.3"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"
version = "1.11.0"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"
version = "1.11.0"

[[deps.BetaReader]]
deps = ["Compat", "DocStringExtensions", "Documenter", "IterTools", "PolytonicGreek", "Test", "TestSetExtensions", "Unicode"]
git-tree-sha1 = "60b527a69c652c9bec74d572ec24181680dfd2f0"
uuid = "e5583720-4bc8-44d1-bd9a-9734450b0166"
version = "2.2.3"

[[deps.BitFlags]]
git-tree-sha1 = "bbe1079eecf9c9fbb52765193ad2bae27ae09bc8"
uuid = "d1d4a3ce-64b1-5f1a-9ba4-7e7e69966f35"
version = "0.1.10"

[[deps.CSV]]
deps = ["CodecZlib", "Dates", "FilePathsBase", "InlineStrings", "Mmap", "Parsers", "PooledArrays", "PrecompileTools", "SentinelArrays", "Tables", "Unicode", "WeakRefStrings", "WorkerUtilities"]
git-tree-sha1 = "8d8e0b0f350b8e1c91420b5e64e5de774c2f0f4d"
uuid = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
version = "0.10.16"

[[deps.CitableBase]]
deps = ["DocStringExtensions", "Documenter", "Test", "TestSetExtensions"]
git-tree-sha1 = "eec0c6a088940306a72f965fe5f9d81cda597d25"
uuid = "d6f014bd-995c-41bd-9893-703339864534"
version = "10.4.0"

[[deps.CitableCorpus]]
deps = ["CitableBase", "CitableText", "CiteEXchange", "DocStringExtensions", "Documenter", "HTTP", "Tables", "Test"]
git-tree-sha1 = "f400484e7b0fc1707f9dfd288fa297a4a2d9a2ad"
uuid = "cf5ac11a-93ef-4a1a-97a3-f6af101603b5"
version = "0.13.5"

[[deps.CitableText]]
deps = ["CitableBase", "DocStringExtensions", "Documenter", "Test", "TestSetExtensions"]
git-tree-sha1 = "00ddf4c75f3e2b8dd54a4e4808b8ec27053d9bb3"
uuid = "41e66566-473b-49d4-85b7-da83b66615d8"
version = "0.16.2"

[[deps.CiteEXchange]]
deps = ["CSV", "CitableBase", "DocStringExtensions", "Documenter", "HTTP", "Test"]
git-tree-sha1 = "da30bc6866a19e0235319c7fa3ffa6ab7f27e02e"
uuid = "e2e9ead3-1b6c-4e96-b95f-43e6ab899178"
version = "0.10.2"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "962834c22b66e32aa10f7611c08c8ca4e20749a9"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.8"

[[deps.Compat]]
deps = ["TOML", "UUIDs"]
git-tree-sha1 = "9d8a54ce4b17aa5bdce0ea5c34bc5e7c340d16ad"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.18.1"
weakdeps = ["Dates", "LinearAlgebra"]

    [deps.Compat.extensions]
    CompatLinearAlgebraExt = "LinearAlgebra"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.3.0+1"

[[deps.ConcurrentUtilities]]
deps = ["Serialization", "Sockets"]
git-tree-sha1 = "21d088c496ea22914fe80906eb5bce65755e5ec8"
uuid = "f0e56b4a-5159-44fe-b623-3e5288b988bb"
version = "2.5.1"

[[deps.DataAPI]]
git-tree-sha1 = "abe83f3a2f1b857aac70ef8b269080af17764bbe"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.16.0"

[[deps.DataStructures]]
deps = ["OrderedCollections"]
git-tree-sha1 = "6fb53a69613a0b2b68a0d12671717d307ab8b24e"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.19.5"

[[deps.DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"
version = "1.11.0"

[[deps.DeepDiffs]]
git-tree-sha1 = "9824894295b62a6a4ab6adf1c7bf337b3a9ca34c"
uuid = "ab62b9b5-e342-54a8-a765-a90f495de1a6"
version = "1.2.0"

[[deps.Dictionaries]]
deps = ["Indexing", "Random", "Serialization"]
git-tree-sha1 = "a55766a9c8f66cf19ffcdbdb1444e249bb4ace33"
uuid = "85a47980-9c8c-11e8-2b9f-f7ca1fa99fb4"
version = "0.4.6"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"
version = "1.11.0"

[[deps.DocStringExtensions]]
git-tree-sha1 = "7442a5dfe1ebb773c29cc2962a8980f47221d76c"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.5"

[[deps.Documenter]]
deps = ["ANSIColoredPrinters", "Base64", "Dates", "DocStringExtensions", "IOCapture", "InteractiveUtils", "JSON", "LibGit2", "Logging", "Markdown", "REPL", "Test", "Unicode"]
git-tree-sha1 = "39fd748a73dce4c05a9655475e437170d8fb1b67"
uuid = "e30172f5-a6a5-5a46-863b-614d45cd2de4"
version = "0.27.25"

[[deps.ExceptionUnwrapping]]
deps = ["Test"]
git-tree-sha1 = "d36f682e590a83d63d1c7dbd287573764682d12a"
uuid = "460bff9d-24e4-43bc-9d9f-a8973cb893f4"
version = "0.1.11"

[[deps.FilePathsBase]]
deps = ["Compat", "Dates"]
git-tree-sha1 = "3bab2c5aa25e7840a4b065805c0cdfc01f3068d2"
uuid = "48062228-2e41-5def-b9a4-89aafe57970f"
version = "0.9.24"
weakdeps = ["Mmap", "Test"]

    [deps.FilePathsBase.extensions]
    FilePathsBaseMmapExt = "Mmap"
    FilePathsBaseTestExt = "Test"

[[deps.Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"
version = "1.11.0"

[[deps.HTTP]]
deps = ["Base64", "CodecZlib", "ConcurrentUtilities", "Dates", "ExceptionUnwrapping", "Logging", "LoggingExtras", "MbedTLS", "NetworkOptions", "OpenSSL", "PrecompileTools", "Random", "SimpleBufferStream", "Sockets", "URIs", "UUIDs"]
git-tree-sha1 = "51059d23c8bb67911a2e6fd5130229113735fc7e"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "1.11.0"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "b6d6bfdd7ce25b0f9b2f6b3dd56b2673a66c8770"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.5"

[[deps.Indexing]]
git-tree-sha1 = "ce1566720fd6b19ff3411404d4b977acd4814f9f"
uuid = "313cdc1a-70c2-5d6a-ae34-0150d3930a38"
version = "1.1.1"

[[deps.InlineStrings]]
git-tree-sha1 = "8f3d257792a522b4601c24a577954b0a8cd7334d"
uuid = "842dd82b-1e85-43dc-bf29-5d0ee9dffc48"
version = "1.4.5"

    [deps.InlineStrings.extensions]
    ArrowTypesExt = "ArrowTypes"
    ParsersExt = "Parsers"

    [deps.InlineStrings.weakdeps]
    ArrowTypes = "31f734f8-188a-4ce0-8406-c8a06bd891cd"
    Parsers = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"
version = "1.11.0"

[[deps.IrrationalConstants]]
git-tree-sha1 = "b2d91fe939cae05960e760110b328288867b5758"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.2.6"

[[deps.IterTools]]
git-tree-sha1 = "42d5f897009e7ff2cf88db414a389e5ed1bdd023"
uuid = "c8e1da08-722c-5040-9ed9-7db0dc04731e"
version = "1.10.0"

[[deps.IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[deps.JLLWrappers]]
deps = ["Artifacts", "Preferences"]
git-tree-sha1 = "7204148362dafe5fe6a273f855b8ccbe4df8173e"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.8.0"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.JuliaSyntaxHighlighting]]
deps = ["StyledStrings"]
uuid = "ac6e5ff7-fb65-4e79-a425-ec3bc9c03011"
version = "1.12.0"

[[deps.LibGit2]]
deps = ["LibGit2_jll", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"
version = "1.11.0"

[[deps.LibGit2_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "OpenSSL_jll"]
uuid = "e37daf67-58a4-590a-8e99-b0245dd2ffc5"
version = "1.9.0+0"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "OpenSSL_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.11.3+1"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"
version = "1.11.0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
version = "1.12.0"

[[deps.LogExpFunctions]]
deps = ["DocStringExtensions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "bba2d9aa057d8f126415de240573e86a8f39d2a1"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "1.0.1"

    [deps.LogExpFunctions.extensions]
    LogExpFunctionsChainRulesCoreExt = "ChainRulesCore"
    LogExpFunctionsChangesOfVariablesExt = "ChangesOfVariables"
    LogExpFunctionsInverseFunctionsExt = "InverseFunctions"

    [deps.LogExpFunctions.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    ChangesOfVariables = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"
version = "1.11.0"

[[deps.LoggingExtras]]
deps = ["Dates", "Logging"]
git-tree-sha1 = "f00544d95982ea270145636c181ceda21c4e2575"
uuid = "e6f89c97-d47a-5376-807f-9c37f3926c36"
version = "1.2.0"

[[deps.Markdown]]
deps = ["Base64", "JuliaSyntaxHighlighting", "StyledStrings"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"
version = "1.11.0"

[[deps.MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "MozillaCACerts_jll", "NetworkOptions", "Random", "Sockets"]
git-tree-sha1 = "8785729fa736197687541f7053f6d8ab7fc44f92"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.1.10"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "ff69a2b1330bcb730b9ac1ab7dd680176f5896b8"
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.1010+0"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "ec4f7fbeab05d7747bdf98eb74d130a2a2ed298d"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.2.0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"
version = "1.11.0"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2025.11.4"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.3.0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.29+0"

[[deps.OpenSSL]]
deps = ["BitFlags", "Dates", "MozillaCACerts_jll", "NetworkOptions", "OpenSSL_jll", "Sockets"]
git-tree-sha1 = "1d1aaa7d449b58415f97d2839c318b70ffb525a0"
uuid = "4d8831e6-92b7-49fb-bdf8-b643e874388c"
version = "1.6.1"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "3.5.4+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "94ba93778373a53bfd5a0caaf7d809c445292ff4"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.8.2"

[[deps.Orthography]]
deps = ["CitableBase", "CitableCorpus", "CitableText", "Compat", "DocStringExtensions", "Documenter", "OrderedCollections", "StatsBase", "Test", "TestSetExtensions", "TypedTables", "Unicode"]
git-tree-sha1 = "a337b43561a8b40890720d21fc2b866424465129"
uuid = "0b4c9448-09b0-4e78-95ea-3eb3328be36d"
version = "0.21.3"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "32a4e09c5f29402573d673901778a0e03b0807b9"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.6"

[[deps.PolytonicGreek]]
deps = ["Compat", "DocStringExtensions", "Documenter", "Orthography", "Test", "TestSetExtensions", "Unicode"]
git-tree-sha1 = "fdd1745051464dfc6fa35d6c870cb5b82b48a290"
uuid = "72b824a7-2b4a-40fa-944c-ac4f345dc63a"
version = "0.21.10"

[[deps.PooledArrays]]
deps = ["DataAPI", "Future"]
git-tree-sha1 = "36d8b4b899628fb92c2749eb488d884a926614d3"
uuid = "2dfb63ee-cc39-5dd5-95bd-886bf059d720"
version = "1.4.3"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "edbeefc7a4889f528644251bdb5fc9ab5348bc2c"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.3.4"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "8b770b60760d4451834fe79dd483e318eee709c4"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.5.2"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"
version = "1.11.0"

[[deps.PtrArrays]]
git-tree-sha1 = "4fbbafbc6251b883f4d2705356f3641f3652a7fe"
uuid = "43287f4e-b6f4-7ad1-bb20-aadabca52c3d"
version = "1.4.0"

[[deps.REPL]]
deps = ["InteractiveUtils", "JuliaSyntaxHighlighting", "Markdown", "Sockets", "StyledStrings", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"
version = "1.11.0"

[[deps.Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"
version = "1.11.0"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.SentinelArrays]]
deps = ["Dates", "Random"]
git-tree-sha1 = "084c47c7c5ce5cfecefa0a98dff69eb3646b5a80"
uuid = "91c51154-3ec4-41a3-a24f-3f23e20d615c"
version = "1.4.10"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"
version = "1.11.0"

[[deps.SimpleBufferStream]]
git-tree-sha1 = "f305871d2f381d21527c770d4788c06c097c9bc1"
uuid = "777ac1f9-54b0-4bf8-805c-2214025038e7"
version = "1.2.0"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"
version = "1.11.0"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "13cd91cc9be159e3f4d95b857fa2aa383b53772a"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.2.3"

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
version = "1.12.0"

[[deps.SplitApplyCombine]]
deps = ["Dictionaries", "Indexing"]
git-tree-sha1 = "55db78e829cf726162fc4fc1b30d05f92092f3f6"
uuid = "03a91e81-4c3e-53e1-a0a4-9c0c8f19dd66"
version = "1.3.0"

[[deps.Statistics]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "ae3bb1eb3bba077cd276bc5cfc337cc65c3075c0"
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.11.1"
weakdeps = ["SparseArrays"]

    [deps.Statistics.extensions]
    SparseArraysExt = ["SparseArrays"]

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "178ed29fd5b2a2cfc3bd31c13375ae925623ff36"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.8.0"

[[deps.StatsBase]]
deps = ["AliasTables", "DataAPI", "DataStructures", "IrrationalConstants", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "e4d7a1a0edc20af42689ea6f4f3587a2175d50ee"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.34.12"

[[deps.StyledStrings]]
uuid = "f489334b-da3d-4c2e-b8f0-e476e12c162b"
version = "1.11.0"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "7.8.3+2"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[deps.Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "OrderedCollections", "TableTraits"]
git-tree-sha1 = "f2c1efbc8f3a609aadf318094f8fc5204bdaf344"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.12.1"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"
version = "1.11.0"

[[deps.TestSetExtensions]]
deps = ["DeepDiffs", "Distributed", "Test"]
git-tree-sha1 = "3a2919a78b04c29a1a57b05e1618e473162b15d0"
uuid = "98d24dd4-01ad-11ea-1b02-c9a08f80db04"
version = "2.0.0"

[[deps.TranscodingStreams]]
git-tree-sha1 = "0c45878dcfdcfa8480052b6ab162cdd138781742"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.11.3"

[[deps.TypedTables]]
deps = ["Adapt", "Dictionaries", "Indexing", "SplitApplyCombine", "Tables", "Unicode"]
git-tree-sha1 = "84fd7dadde577e01eb4323b7e7b9cb51c62c60d4"
uuid = "9d95f2ec-7b3d-5a63-8d20-e2491e220bb9"
version = "1.4.6"

[[deps.URIs]]
git-tree-sha1 = "bef26fb046d031353ef97a82e3fdb6afe7f21b1a"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.6.1"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"
version = "1.11.0"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"
version = "1.11.0"

[[deps.WeakRefStrings]]
deps = ["DataAPI", "InlineStrings", "Parsers"]
git-tree-sha1 = "0716e01c3b40413de5dedbc9c5c69f27cddfddfc"
uuid = "ea10d353-3f73-51f8-a26c-33c1cb351aa5"
version = "1.4.3"

[[deps.WorkerUtilities]]
git-tree-sha1 = "cd1659ba0d57b71a464a29e64dbc67cfe83d54e7"
uuid = "76eceee3-57b5-4d4a-8e66-0e911cebbf60"
version = "1.6.1"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.3.1+2"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.15.0+0"
"""

# ╔═╡ Cell order:
# ╟─6803fb60-4024-40d3-89a3-610b3caba42a
# ╟─7bc16f5c-a123-45a0-a210-f407d88dbb66
# ╟─ab1bf088-5aed-4398-b9f9-f233e6fc80d9
# ╠═4637d894-708e-11f1-b4d1-47c320d96d7b
# ╠═dd5741f2-5ec7-4d89-9e3d-7f5848269c4a
# ╠═da53747d-d3d3-4d99-85fe-8466206f41a4
# ╠═d57bfe5d-d77c-4f28-9843-20b783b25d00
# ╠═31da7d95-eb1a-4fd2-aee3-ee10aba834fc
# ╠═e602f9ad-7fc1-4830-8497-dadf6dd245ae
# ╠═e2499df2-bbcf-4d30-a091-94093ec3a117
# ╠═e9986b55-1814-4049-a656-0610c31d13d2
# ╠═d26fafc6-022c-407f-add3-1ae9c3f86f76
# ╠═803d93cd-87bc-4d4c-9788-ddc7befbd801
# ╠═77ad52d0-c403-4fa7-b03d-ceb112d2a797
# ╠═3205a6bb-f7ee-49a8-85d5-16531d7b1604
# ╠═dd50253e-6fed-4a33-9bc8-4cc742ade9bf
# ╠═58218ba6-249a-4ea6-b6db-2e98c2401df5
# ╠═f40a0c14-b416-4224-9396-68b8d0554642
# ╠═3c587bf5-f28c-4edf-bb3d-0fc492476660
# ╠═c6890474-f545-4bd6-866d-69b8e51bae27
# ╠═dcebf70e-89c7-41f7-9580-da0a85127e04
# ╠═364dd178-3d95-4ce8-80e8-0b9e53045f87
# ╠═3298fa0a-775e-478a-9d1f-bfd76a5f7163
# ╠═6e91e903-d211-4300-a7d3-a88a54e5b561
# ╠═c7e643a3-92bf-4e15-92d6-c8e2d5156578
# ╠═d933b5e5-627d-47de-80b9-313e7a6e2cd7
# ╠═ec5d11c4-2bd3-4003-95c1-79eb4adedf67
# ╠═58053e2f-f6fb-4e52-b2a0-5e8307121012
# ╠═294f3e9c-6f60-455e-9812-94895e87f3a3
# ╠═c2f42d0b-6127-4fb7-9077-54b06bd0e01a
# ╠═6beffdf9-efc6-49f2-865e-66818fc49f1c
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
