map(
	.name as $name
	| .versions.stable as $version
	|
		.bottle.stable.files | to_entries | map({
			path: "\($name)/\($version)/\(.key)",
			url: .value.url
		})
)
| flatten
| map("\(.path).url=\(.url)")
| .[]
