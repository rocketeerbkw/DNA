#pragma once

class CAutoCS
{
	private:
		CRITICAL_SECTION * m_pcs;
	public:
		CAutoCS(CRITICAL_SECTION * pcs) : m_pcs(pcs)
		{
			EnterCriticalSection(m_pcs);
		}

		~CAutoCS()
		{
			LeaveCriticalSection(m_pcs);
		}
};
