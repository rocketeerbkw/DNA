#ifndef DLL_H
#define DLL_H

#if defined (_DLL)
	#define DllExport __declspec(dllexport)
#elif defined (EXPORTALL)
	#define DllExport __declspec(dllexport)
#else
	#define DllExport
#endif

#endif
