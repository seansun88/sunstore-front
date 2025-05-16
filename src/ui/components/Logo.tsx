"use client";

import { usePathname } from "next/navigation";
import Image from "next/image";
import { LinkWithChannel } from "../atoms/LinkWithChannel";

const companyName = "LOVEFURBABY";

export const Logo = () => {
	const pathname = usePathname();

	if (pathname === "/") {
		return (
			<h1 className="flex items-center font-bold" aria-label="homepage">
				<Image src="/logo.png" alt="LOVEFURBABY Logo" width={40} height={40} className="mr-2" />
				{companyName}
			</h1>
		);
	}
	return (
		<div className="flex items-center font-bold">
			<LinkWithChannel aria-label="homepage" href="/">
				<div className="flex items-center">
					<Image src="/logo.png" alt="LOVEFURBABY Logo" width={130} height={60} className="mr-2" />
					{/* {companyName} */}
				</div>
			</LinkWithChannel>
		</div>
	);
};
