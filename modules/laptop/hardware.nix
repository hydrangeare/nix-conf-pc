{ pkgs, ...}:
{
  boot.initrd.kernelModules = [ "amdgpu" ];
  services.xserver.videoDrivers = [ "amdgpu" ];
  hardware.opengl = {
    extraPackages = with pkgs; [
      rocmPackages.clr.icd
      amdvlk
	 driversi686Linux.amdvlk
    ];
    driSupport = true;
    driSupport32Bit = true;
  };
}
