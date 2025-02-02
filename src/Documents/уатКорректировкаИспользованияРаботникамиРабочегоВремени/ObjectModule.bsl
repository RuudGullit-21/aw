#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроведения(Отказ, Режим)
    
	// Инициализация дополнительных свойств для проведения документа.
	уатПроведение.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Инициализация данных документа.
	Документы.уатКорректировкаИспользованияРаботникамиРабочегоВремени.ИнициализироватьДанныеДокумента(Ссылка,
		ДополнительныеСвойства);
	
	// Подготовка наборов записей.
	уатПроведение.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Отражение в разделах учета.
	Если ВидОперации = Перечисления.уатВидыОперацийКорректировкаРабочегоВремени.План Тогда
		уатПроведение.ОтразитьКорректировкуПланаРабочегоВремениСотрудников(ДополнительныеСвойства, Движения, Отказ);
	Иначе
		уатПроведение.ОтразитьРабочееВремяРаботниковОрганизаций(ДополнительныеСвойства, Движения, Отказ);
	КонецЕсли;
	
	// Запись наборов записей.
	уатПроведение.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	// Контроль возникновения отрицательного остатка.
	Документы.уатКорректировкаИспользованияРаботникамиРабочегоВремени.ВыполнитьКонтроль(Ссылка, ДополнительныеСвойства,
		Отказ);
	
КонецПроцедуры 

Процедура ОбработкаУдаленияПроведения(Отказ)
		
	// Инициализация дополнительных свойств для проведения документа
	уатПроведение.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	уатПроведение.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Запись наборов записей
	уатПроведение.ЗаписатьНаборыЗаписей(ЭтотОбъект);

	// Контроль
	Документы.уатКорректировкаИспользованияРаботникамиРабочегоВремени.ВыполнитьКонтроль(Ссылка, ДополнительныеСвойства,
		Отказ, Истина);


КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	уатОбщегоНазначенияСервер.Заполнить(ЭтотОбъект, ДанныеЗаполнения);
КонецПроцедуры

#КонецОбласти

#КонецЕсли