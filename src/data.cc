#include "data.h"

/************************************************************
 * Constructors                                             *
 ************************************************************/
PsiData::PsiData (
	std::vector<double> x,
	std::vector<int>    N,
	std::vector<int>    k,
	int nAFC
	) :
	intensities(x), Ntrials(N), Ncorrect(k), Pcorrect(k.size()), Nalternatives(nAFC), logNoverK(k.size())
{
	int i,n;
	for ( i=0; i<k.size(); i++ ) {
		Pcorrect[i] = double(Ncorrect[i])/Ntrials[i];
		logNoverK[i] = 0;
		for ( n=1; n<=k[i]; n++ )
			logNoverK[i] += log(N[i]+1-n) - log(n);
	}
}

PsiData::PsiData (
	std::vector<double> x,
	std::vector<int>    N,
	std::vector<double> p,
	int nAFC
	) :
	intensities(x), Ntrials(N), Ncorrect(p.size()), Pcorrect(p), Nalternatives(nAFC)
{
	int i;
	double k;
	for ( i=0; i<p.size(); i++ ) {
		k = Ntrials[i] * Pcorrect[i];
		if ( fabs(k-int(k)) > 1e-7 )    // The fraction of correct responses does not correspond to an integer number of correct responses
			std::cerr << "WARNING: fraction of correct responses does not correspond to an integer number of correct responses!\n";
		Ncorrect[i] = int(k);
	}
}

/************************************************************
 * Setters                                                  *
 ************************************************************/

void PsiData::setNcorrect ( const std::vector<int>& newNcorrect )
{
	Ncorrect = newNcorrect;
	int i;
	for ( i=0; i<Ncorrect.size(); i++ )
		Pcorrect[i] = double(Ncorrect[i])/Ntrials[i];
}

/************************************************************
 * Getters                                                  *
 ************************************************************/

// TODO: implement these as inline functions?

const std::vector<double>& PsiData::getIntensities ( void ) const
{
    return intensities;
}

const std::vector<int>& PsiData::getNtrials ( void ) const
{
    return Ntrials;
}

const std::vector<int>& PsiData::getNcorrect ( void ) const
{
    return Ncorrect;
}

const std::vector<double>& PsiData::getPcorrect ( void ) const
{
    return Pcorrect;
}

double PsiData::getIntensity ( int i ) const
{
	if ( i>=0 && i<intensities.size() )
		return intensities[i];
	else
		throw BadIndexError();
}

int PsiData::getNtrials ( int i ) const
{
	if ( i>=0 && i<Ntrials.size() )
		return Ntrials[i];
	else
		throw BadIndexError();
}

int PsiData::getNcorrect ( int i ) const
{
	if ( i>=0 && i<Ncorrect.size() )
		return Ncorrect[i];
	else
		throw BadIndexError();
}

double PsiData::getPcorrect ( int i ) const
{
	if ( i>=0 && i<Pcorrect.size() )
		return Pcorrect[i];
	else
		throw BadIndexError();
}

double PsiData::getNoverK ( int i ) const
{
	if ( i>=0 && i<logNoverK.size() )
		return logNoverK[i];
	else
		throw BadIndexError();
}

int PsiData::getNalternatives ( void ) const
{
	return Nalternatives;
}