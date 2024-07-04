
//////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ
#Область ОбработчикиСобытий

Процедура ОбработкаПроведения(Отказ, Режим)
	// Инициализация дополнительных свойств для проведения документа.
	уатПроведение.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	Документы.уатПеремещениеАгрегатов.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей.
	уатПроведение.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	уатПроведение.ОтразитьОстаткиАгрегатов(ДополнительныеСвойства, Движения, Отказ);
	
	уатПроведение.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	Документы.уатПеремещениеАгрегатов.ВыполнитьКонтроль(Ссылка, ДополнительныеСвойства, Отказ);
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	// Заголовок для сообщений об ошибках проведения.
	Заголовок = уатОбщегоНазначенияТиповые.уатПредставлениеДокументаПриПроведении(ЭтотОбъект);
	
	СтруктураШапкиДокумента = Новый Структура("СкладОтправитель, СкладПолучатель, Организация");
	уатОбщегоНазначенияТиповые.уатПроверитьЗаполнениеШапкиДокумента(ЭтотОбъект, СтруктураШапкиДокумента, Отказ, 
																	Заголовок);
	
	СтруктураПолей = Новый Структура("СерияНоменклатуры");
	уатОбщегоНазначенияТиповые.уатПроверитьЗаполнениеТабличнойЧасти(ЭтотОбъект, "Шины", СтруктураПолей, Отказ, Заголовок);
	уатОбщегоНазначенияТиповые.уатПроверитьЗаполнениеТабличнойЧасти(ЭтотОбъект, "Аккумуляторы", СтруктураПолей, Отказ,
																	Заголовок);
	
	уатОбщегоНазначения.ПроверкаЗаполненияПодразделения(Организация, Подразделение, Отказ, Заголовок);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Инициализация дополнительных свойств для проведения документа
	уатПроведение.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	уатПроведение.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Запись наборов записей
	уатПроведение.ЗаписатьНаборыЗаписей(ЭтотОбъект);

	// Контроль
	Документы.уатПеремещениеАгрегатов.ВыполнитьКонтроль(Ссылка, ДополнительныеСвойства, Отказ, Истина);

КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	уатОбщегоНазначенияСервер.Заполнить(ЭтотОбъект, ДанныеЗаполнения);
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.уатПоступлениеАгрегатов") 
		Или ТипЗнч(ДанныеЗаполнения) = Тип("ДокументОбъект.уатПоступлениеАгрегатов") Тогда
		
		Дата              = ТекущаяДата();
		Комментарий       = "Заполнен на основании " + ДанныеЗаполнения;
		МОЛ               = ДанныеЗаполнения.МОЛ;
		Организация       = ДанныеЗаполнения.Организация;
		Ответственный     = ДанныеЗаполнения.Ответственный;
		Подразделение     = ДанныеЗаполнения.Подразделение;
		СкладОтправитель  = ДанныеЗаполнения.Склад;
		ДокументОснование = ДанныеЗаполнения.Ссылка;
		
		Для Каждого ТекСтрокаАккумуляторы Из ДанныеЗаполнения.Аккумуляторы Цикл
			НоваяСтрока = Аккумуляторы.Добавить();
			НоваяСтрока.СерияНоменклатуры = ТекСтрокаАккумуляторы.СерияНоменклатуры;
		КонецЦикла;
		Для Каждого ТекСтрокаПрочиеАгрегаты Из ДанныеЗаполнения.ПрочиеАгрегаты Цикл
			НоваяСтрока = ПрочиеАгрегаты.Добавить();
			НоваяСтрока.СерияНоменклатуры = ТекСтрокаПрочиеАгрегаты.СерияНоменклатуры;
		КонецЦикла;
		Для Каждого ТекСтрокаШины Из ДанныеЗаполнения.Шины Цикл
			НоваяСтрока = Шины.Добавить();
			НоваяСтрока.СерияНоменклатуры = ТекСтрокаШины.СерияНоменклатуры;
		КонецЦикла;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти
