#Область ОбработчикиСобытий

&НаКлиенте
// Процедура - обработчик выполнения команды
//
// Параметры:
//	ПараметрКоманды				- Произвольный	- Параметр команды
//	ПараметрыВыполненияКоманды	- Структура		- Параметры выполнения команды
//
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	ПараметрыФормы = Новый Структура("Пользователь", ПараметрКоманды);
	ОткрытьФорму("ОбщаяФорма.сфпПерсональныеНастройки", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно);
КонецПроцедуры // ОбработкаКоманды() 

#КонецОбласти