
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Параметры.Свойство("ПунктОтправления", ПунктОтправления);
	Параметры.Свойство("Грузоотправитель", Грузоотправитель);
	Параметры.Свойство("Грузополучатель", Грузополучатель);
	Параметры.Свойство("ДнейДоОтправления", ДнейДоОтправления);
	Параметры.Свойство("ДнейВПути", ДнейВПути);
	Параметры.Свойство("FTL", FTL);
	Если Параметры.Свойство("ИзменениеСвойств") Тогда
		Элементы.ГруппаПодсказка.Видимость = Параметры.ИзменениеСвойств;
	КонецЕсли;
	Элементы.FTL.Видимость = уатОбщегоНазначенияПовтИсп.ВариантПоставкиКОРП();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОсновныеДействияФормыОК(Команда)
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	РезультатЗакрытия = Новый Структура("ПунктОтправления, Грузоотправитель, Грузополучатель, 
		|ДнейДоОтправления, ДнейВПути, FTL");
	ЗаполнитьЗначенияСвойств(РезультатЗакрытия, ЭтаФорма);
	Закрыть(РезультатЗакрытия);	
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти