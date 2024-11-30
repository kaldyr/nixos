{

	# Manual interventions required!!!
	# Disko cannot apply chattr settings
	# Disko cannot yet handle multiple device btrfs
	# The storage array should not be managed by Disko to preserve data
	disko.devices.disk.main = {

		device = "";
		type = "disk";

		content = {

			type = "gpt";

			partitions = {

				ESP = {

					name = "ESP";
					type = "EF00";
					start = "1MiB";
					size = "2G";

					content = {
						type = "filesystem";
						format = "vfat";
						extraArgs = [ "-F" "32" ];
						mountpoint = "/boot";
						mountOptions = [ "defaults" ];
					};

				};

				main = {

					size = "100%";

					content = {

						type = "btrfs";
						extraArgs = [ "-f" ];

						subvolumes = let
							# btrfs subvolumes must all have the same mount options for now.
							driveOptions = [ "noatime" "discard=async" "compress-force=zstd:3" ];
						in {
							# SSH subvolume.  Race condition when symlinking and/or persisting with sops-nix
							"@etc_ssh" = { mountpoint = "/etc/ssh"; mountOptions = driveOptions; };
							# Files to be preserved between boots that can be regenerated easily
							"@nix" = { mountpoint = "/nix"; mountOptions = driveOptions; };
							# Files to be preserved between boots and be backed up to restore machine state
							"@state" = { mountpoint = "/state"; mountOptions = driveOptions; };
							# Snapshot storage
							"@snaps" = { mountpoint = "/snaps"; mountOptions = driveOptions; };
							# Swapfile
							"@swap" = { mountpoint = "/swap"; swap.swapfile.size = "8G"; };
						};

					};

				};

			};

		};

	};

}
